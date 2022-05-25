Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A1F533EE4
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 16:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbiEYOMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 10:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbiEYOMf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 10:12:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D966ABF64
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 07:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653487953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A3L6WGFmdy6pwHnD+6q3GnwdUEW6LAQ5NplSTSpXSVk=;
        b=J1z51S5cYfxKtpOcP1cia5p1vksPNpMSi8ji44R/8KrYlthePuyorW8H0FdMR/e0NXxGft
        8eFwf0UvhCmaZQxpes5g9T4Ed64CUb19jhr56636jsA54Y9/gIQ1KVoS7sUQWa3H55ntCn
        0d1E0L6yXGbackG0iaL3cQ99n2O0a7k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-S3JMU0leMleIbqNi_H8DWQ-1; Wed, 25 May 2022 10:12:30 -0400
X-MC-Unique: S3JMU0leMleIbqNi_H8DWQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C864329AA2F8;
        Wed, 25 May 2022 14:12:29 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B411C15E71;
        Wed, 25 May 2022 14:12:27 +0000 (UTC)
Message-ID: <48b495c5610d25596a268c71b627b2e2136ac0bd.camel@redhat.com>
Subject: Re: [PATCH RESEND v12 00/17] KVM: x86/pmu: Add basic support to
 enable guest PEBS via DS
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Wed, 25 May 2022 17:12:26 +0300
In-Reply-To: <289d0c88-36a0-afd4-4d47-f2db3fb63654@gmail.com>
References: <20220411101946.20262-1-likexu@tencent.com>
         <87fsl5u3bg.fsf@redhat.com>
         <e0b96ebd-00ee-ead4-cf35-af910e847ada@gmail.com>
         <d7461fd4-f6ec-1a0b-6768-0008a3092add@gmail.com>
         <874k1ltw9y.fsf@redhat.com>
         <f379a933-15b0-6858-eeef-5fbef6e5529c@gmail.com>
         <0848a2da-c9cf-6973-c774-ff16c3e8a248@redhat.com>
         <289d0c88-36a0-afd4-4d47-f2db3fb63654@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-25 at 16:32 +0800, Like Xu wrote:
> On 25/5/2022 4:14 pm, Paolo Bonzini wrote:
> > On 5/25/22 09:56, Like Xu wrote:
> > > Thanks for the clarification.
> > > 
> > > Some kvm x86 selftests have been failing due to this issue even after the last 
> > > commit.
> > > 
> > > I blame myself for not passing the msr_info->host_initiated to the 
> > > intel_is_valid_msr(),
> > > meanwhile I pondered further whether we should check only the MSR addrs range in
> > > the kvm_pmu_is_valid_msr() and apply this kind of sanity check in the 
> > > pmu_set/get_msr().
> > > 
> > > Vitaly && Paolo, any preference to move forward ?
> > 
> > I'm not sure what I did wrong to not see the failure, so I'll fix it myself.
> 
> More info, some Skylake hosts fail the tests like x86_64/state_test due to this 
> issue.
> 
> > But from now on, I'll have a hard rule of no new processor features enabled 
> > without KVM unit tests or selftests.  In fact, it would be nice if you wrote 
> > some for PEBS.
> 
> Great, my team (or at least me) is committed to contributing more tests on vPMU 
> features.
> 
> We may update the process document to the 
> Documentation/virt/kvm/review-checklist.rst.
> 
> > Paolo
> > 

FYI, this patch series also break 'msr' test in kvm-unit tests.
(kvm/queue of today, and master of the kvm-unit-tests repo)

The test tries to set the MSR_IA32_MISC_ENABLE to 0x400c51889 and gets #GP.


Commenting this out, gets rid of #GP, but test still fails with unexpected result

		if (!msr_info->host_initiated &&
		    ((old_val ^ data) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL))
			return 1;




It is very possible that the test is broken, I'll check this later.

Best regards,
	Maxim Levitsky

