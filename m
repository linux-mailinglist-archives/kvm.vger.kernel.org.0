Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9521154B428
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 17:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344004AbiFNPEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 11:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237229AbiFNPEF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 11:04:05 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148523F899
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 08:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655219044; x=1686755044;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vBT99UBeikr69ry65nHXwY0Ra78dk8nIRvWd0KDNFL4=;
  b=FBwCLwjhlJhAzzGG188tnK9wtc9LCvRKlPpB9LM7k2OAxEq/JHiOw1gV
   qnQtaf48G6dWIEXTat3N6V8ljKf+k3iNOTssTBbR3MtpOPs1w9UekZ5BO
   Kb7R8xY5tsyQIJVRhCIMxWmTqzaL4dpqOhfvBRweLH5r/Kfwu20xBwAwV
   0IyE/51xPJJ6BhoszgwyRQmGQeJ/0O8kovW37Am+cVsfmiDCODW8NzHKo
   ujX6SrM7GLSI3PnFJsuIGd4ol2iqPea90zovgiGZTZkvpL55yjPKpU7Kf
   bXBH2M1BhWD3L3NiPpQM7hENnhLuRFgM/N4oloFwpZXD2Dk1GjTO5OeoQ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="304057963"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="304057963"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 08:03:42 -0700
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="588512844"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 08:03:38 -0700
Date:   Tue, 14 Jun 2022 23:03:25 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     wangguangju <wangguangju@baidu.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org, dave.hansen@linux.intel.co,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.orga
Subject: Re: [PATCH] KVM: x86: add a bool variable to distinguish whether to
 use PVIPI
Message-ID: <20220614150319.GA13174@gao-cwp>
References: <1655124522-42030-1-git-send-email-wangguangju@baidu.com>
 <YqdxAFhkeLjvi7L5@google.com>
 <20220614025434.GA15042@gao-cwp>
 <YqieGua0ouUePWol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqieGua0ouUePWol@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 02:41:30PM +0000, Sean Christopherson wrote:
>> PVIPI is mainly [*] for sending multi-cast IPIs. Intel IPI virtualization
>> can virtualize only uni-cast IPIs. Their use cases don't overlap. So, I
>> don't think it makes sense to disable PVIPI if intel IPI virtualization
>> is supported.
>> 
>> The question actually is how to deal with the exceptional case below.
>> Considering the migration case Sean said below, it is hard to let VM
>> always work in the ideal way unless KVM notifies VM of migration and VM
>> changes its behavior on receiving such notifications. But since x2apic
>> has better performance than xapic, if VM cares about performance, it can
>> simply switch to x2apic mode. All things considered, I think the
>> performance gain isn't worth the complexity added. So, I prefer to leave
>> it as is.
>> 
>> [*]: when linux guest is in *xapic* mode, it uses PVIPI to send uni-case IPI.
>
>Hmm, there are definitely guests that run xAPIC though, even if x2apic is supported.
>
>That said, I tend to agree that trying to handle this in KVM and/or the guest kernel
>is going to get messy.  The easiest solution is for VMMs to not advertise PV IPIs
>when the VM is going to predominately run on hosts with IPIv.

But it will hurt multi-cast IPIs in VMs. IMO, a feasible solution is to add
a new hint to indicate IPI virtualization is enabled and VM uses native
interface (writes to ICR) to send uni-cast IPIs in xapic mode if it sees
the new hint.
