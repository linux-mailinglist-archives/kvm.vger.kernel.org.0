Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951CB3006CA
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 16:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbhAVPMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 10:12:20 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:40061 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729149AbhAVPMI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 10:12:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UMX2LXt_1611328270;
Received: from IT-FVFX43SYHV2H.local(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0UMX2LXt_1611328270)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 Jan 2021 23:11:11 +0800
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, yj226063@alibaba-inc.com
From:   Alex Shi <alex.shi@linux.alibaba.com>
Subject: 3 preempted variables in kvm
Message-ID: <b6398228-31b9-ca84-873b-4febbd37c87d@linux.alibaba.com>
Date:   Fri, 22 Jan 2021 23:11:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.0; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi All,

I am newbie on KVM side, so probably I am wrong on the following.
Please correct me if it is.

There are 3 preempted variables in kvm:
     1, kvm_vcpu.preempted  in include/linux/kvm_host.h
     2, kvm_steal_time.preempted 3, kvm_vcpu_arch.st.preempted in arch/x86
Seems all of them are set or cleared at the same time. Like,

vcpu_put:
        kvm_sched_out()-> set 3 preempted
                kvm_arch_vcpu_put():
                        kvm_steal_time_set_preempted

vcpu_load:
        kvm_sched_in() : clear above 3 preempted
                kvm_arch_vcpu_load() -> kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
                request dealed in vcpu_enter_guest() -> record_steal_time

Except the 2nd one reuse with KVM_FEATURE_PV_TLB_FLUSH bit which could be used
separately, Could we combine them into one, like just bool kvm_vcpu.preempted? and 
move out the KVM_FEATURE_PV_TLB_FLUSH. Believe all arch need this for a vcpu overcommit.

Thanks
Alex
