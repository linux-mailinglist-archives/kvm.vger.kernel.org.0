Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D154B6CEFB7
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 18:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjC2QrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 12:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbjC2QrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 12:47:18 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5892C5261
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 09:47:17 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5411f21f849so161369457b3.16
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 09:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680108436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XhJ2KAFNUebvt6cQMDTLf5QYVLkhRGTjjjB4Lv8Q8Pw=;
        b=Nwnor0fuwBFL6HswHVDb9zq4uqB8N0vyANtOGoursE/xCXttz4V6jsoxjL4SKGjtcU
         vM08UOGTQy3ImsotSEpEn8ev+cnvKUAvL56SaS8B8FBrIaQIcJJDDjylIjDObxUSVj3m
         /QZ2b+8/qsofV6UllwSgZtticUjx9NgZ0p3PXNaUQQJNdVnoAIr1IyMyMkDLhy+jZkvd
         3nt/k1QOxZXpVzmtl9BOim/yPZvH5Vvs4toGP76nX15+oc8clHEikoh1Mn2zLLjO+KnC
         Nb14v+ooTd2RMCQTcprG20lhhxICTFeqHyl2aaxr+1MLBrctSNDVouYcDHucWdrm7uP3
         p9iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680108436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XhJ2KAFNUebvt6cQMDTLf5QYVLkhRGTjjjB4Lv8Q8Pw=;
        b=Ky4wGHTQS8nBBSTrIgQ4aFkPyKGVFZVLTzqUtno4k2VQuS2h3zQsf0YSTYrepWaNZd
         ttKvceln05CPQVfKDB7KZn5qWpxlM9DZ4dSMhhmpfeXsArF3NlNSJnb65vm79tTS+DyY
         dJamAnO0l99lyTbUvcSoNc62fUQH7q82RZDYSCbR3SKNGIP8a5YLN799rdmUYX4f70Zw
         TxmDL5xvNWM2eSGIwtP4+OQ2R2JHFN6M9aSIoSOLaSO0TkO9kJaT3lBCW1ikxA3CP15B
         R4LxqWhJ7/MnUc96oePVbNtLinrmoavNlfZBVncNtcJ/SztUd1zQuFzavBUxENcyOhvB
         4sYA==
X-Gm-Message-State: AAQBX9evkrixtePgbMQMJT+963h6A9OgI12cgAvbwDkvszN6BFeompoi
        s19c0r2C8D4cJBZwS2BrftnBN11fqO0=
X-Google-Smtp-Source: AKy350aIOO/FRysptnp/XYsHQcm9j9T0hsEhp7XgPOREaWpwy9KrpbLjRF48BgXvySig/ZWmHz4PQEOOPoU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:b94:b0:541:698b:7bdb with SMTP id
 ck20-20020a05690c0b9400b00541698b7bdbmr1769126ywb.2.1680108436600; Wed, 29
 Mar 2023 09:47:16 -0700 (PDT)
Date:   Wed, 29 Mar 2023 09:47:15 -0700
In-Reply-To: <38601264-1957-579f-f156-c782bb9826cc@amd.com>
Mime-Version: 1.0
References: <20230206060545.628502-1-manali.shukla@amd.com>
 <20230206060545.628502-3-manali.shukla@amd.com> <ZB4AOaLRwSB0ClIH@google.com> <38601264-1957-579f-f156-c782bb9826cc@amd.com>
Message-ID: <ZCRrk0qsdv7rYqFq@google.com>
Subject: Re: [RFC PATCH kernel 2/2] KVM: SEV: PreventHostIBS enablement for
 SEV-ES and SNP guest
From:   Sean Christopherson <seanjc@google.com>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, jolsa@kernel.org,
        namhyung@kernel.org, tglx@linutronix.de, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com,
        jpoimboe@kernel.org, pawan.kumar.gupta@linux.intel.com,
        babu.moger@amd.com, sandipan.das@amd.com, jmattson@google.com,
        thomas.lendacky@amd.com, nikunj@amd.com, ravi.bangoria@amd.com,
        eranian@google.com, irogers@google.com, kvm@vger.kernel.org,
        x86@kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 29, 2023, Manali Shukla wrote:
> On 3/25/2023 1:25 AM, Sean Christopherson wrote:
> > On Mon, Feb 06, 2023, Manali Shukla wrote:
> >> -	if (sev_es_guest(vcpu->kvm))
> >> +	if (sev_es_guest(vcpu->kvm)) {
> >> +		bool ibs_fetch_active, ibs_op_active;
> >> +		u64 ibs_fetch_ctl, ibs_op_ctl;
> >> +
> >> +		if (svm->prevent_hostibs_enabled) {
> >> +			/*
> >> +			 * With PreventHostIBS enabled, IBS profiling cannot
> >> +			 * be active when VMRUN is executed. Disable IBS before
> >> +			 * executing VMRUN and, because of a race condition,
> >> +			 * enable the PreventHostIBS window if IBS profiling was
> >> +			 * active.
> > 
> > And the race can't be fixed because...?
> 
> Race can not be fixed because VALID and ENABLE bit for IBS_FETCH_CTL and IBS_OP_CTL
> are contained in their same resepective MSRs. Due to this reason following scenario can
> be generated:
> Read IBS_FETCH_CTL (IbsFetchEn bit is 1 and IBSFetchVal bit is 0)
> Write IBS_FETCH_CTL (IbsFetchEn is 0 now)
> Imagine in between Read and Write, IBSFetchVal changes to 1. Write to IBS_FETCH_CTL will
> clear the IBSFetchVal bit. When STGI is executed after VMEXIT, the NMI is taken and check for
> valid mask will fail and generate Dazed and Confused NMI messages.
> Please refer to cover letter for more details.

I understand the race, I'm asking why this series doesn't fix the race.  Effectively
suppressing potentially unexpected NMIs because PreventHostIBS was enable is ugly.

> >> +			 */
> >> +			ibs_fetch_active =
> >> +				amd_disable_ibs_fetch(&ibs_fetch_ctl);
> >> +			ibs_op_active =
> >> +				amd_disable_ibs_op(&ibs_op_ctl);
> >> +
> >> +			amd_prevent_hostibs_window(ibs_fetch_active ||
> >> +						   ibs_op_active);
> >> +		}
> >> +
> >>  		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
> >> -	else
> >> +
> >> +		if (svm->prevent_hostibs_enabled) {
> >> +			if (ibs_fetch_active)
> >> +				amd_restore_ibs_fetch(ibs_fetch_ctl);
> >> +
> >> +			if (ibs_op_active)
> >> +				amd_restore_ibs_op(ibs_op_ctl);
> > 
> > IIUC, this adds up to 2 RDMSRs and 4 WRMSRs to the VMRUN path.  Blech.  There's
> > gotta be a better way to implement this.  
> 
> I will try to find a better way to implement this.
> 
> > Like PeterZ said, this is basically
> > exclude_guest.
> 
> As I mentioned before, exclude_guest lets the profiler decide whether it wants to trace the guest
> data or not, whereas PreventHostIBS lets the owner of the guest decide whether host can trace guest's
> data or not.

PreventHostIBS is purely an enforcement, it does not actually do anything to
disable tracing of the guest.  What PeterZ and I are complaining about is that
instead of integrating this feature with exclude_guest, e.g. finding a way to
make guest tracing mutually exclusive with KVM_RUN so that PreventHostIBS can be
contexted switched according, this series instead backdoors into perf to forcefully
disable tracing.

In other words, please try to create a sane contract between userspace, perf, and
KVM, e.g. disallow tracing a guest with PreventHostIBS at some level instead of
silently toggling tracing around VMRUN.
