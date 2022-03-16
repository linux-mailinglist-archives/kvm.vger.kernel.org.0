Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E394DA8FE
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 04:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353477AbiCPDp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 23:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245499AbiCPDp5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 23:45:57 -0400
Received: from out0-158.mail.aliyun.com (out0-158.mail.aliyun.com [140.205.0.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD4827B0E
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 20:44:43 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047187;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.N5YaCow_1647402281;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.N5YaCow_1647402281)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Mar 2022 11:44:41 +0800
Date:   Wed, 16 Mar 2022 11:44:41 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: document limitations of MSR filtering
Message-ID: <20220316034441.GB62465@k08j02272.eu95sqa>
References: <20220315221729.2416555-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315221729.2416555-1-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 16, 2022 at 06:17:29AM +0800, Paolo Bonzini wrote:
> MSR filtering requires an exit to userspace that is hard to implement and
> would be very slow in the case of nested VMX vmexit and vmentry MSR
> accesses.  Document the limitation.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 0e08253b003f..8911a4310406 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4091,6 +4091,11 @@ x2APIC MSRs are always allowed, independent of the ``default_allow`` setting,
>  and their behavior depends on the ``X2APIC_ENABLE`` bit of the APIC base
>  register.
>  
> +.. warning::
> +   MSR accesses coming from nested vmentry/vmexit are not filtered.
> +   This includes both writes to individual VMCS fields and reads/writes
> +   through the MSR lists pointed to by the VMCS.
> +
Should we document that only MSR accesses coming from rdmsr/wrmsr are
filtered? Other instructions like RDPID/RDTSCP can also do MSR access,
but can't be filtered by msr bitmap.

>  If a bit is within one of the defined ranges, read and write accesses are
>  guarded by the bitmap's value for the MSR index if the kind of access
>  is included in the ``struct kvm_msr_filter_range`` flags.  If no range
> -- 
> 2.31.1
