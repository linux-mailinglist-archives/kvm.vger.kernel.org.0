Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD295F815C
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 01:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiJGXsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 19:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJGXsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 19:48:52 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C252ACCD
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 16:48:51 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id l4so5841210plb.8
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 16:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V/Q7jk+h4kiXbxXJZs3+SZab/9Za53ua+9OHBQKlFeY=;
        b=OVSThHoEa5amM+vb5o2QLgMsr1bK49k9/ZEbyxIshWGIrzyfk0Fc/V4910mjXK7xkP
         7e8kZh5GSYKZ3eqzREDdDLQPHg2RtW2vjcMxrv9Z0yb6rx+igShEwAWjFw0CRoXqYCIJ
         aGMHH/TaaWPK4IMQRGZiGVU3djsnkpt9+uDqmO4JWUXub+QvJKWvOKmG+OfDuuTikt6t
         MIo8mhUkqAj9bBjZrP2/ymhFK2qhy7GaV+wYQxksmwGzfphe3PoZUoEkFrO1qeRgzKSK
         y9LRoRYgRZkDwqj2Avk8BhAYQ40SmSxgX0R1ogIbhH14uQGiziUJpgIeXxar2qiYZlgT
         9pmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/Q7jk+h4kiXbxXJZs3+SZab/9Za53ua+9OHBQKlFeY=;
        b=r0IERpXMcddcyrSH+wWvKBMORVQr0p5OL1/pVcRsY6poperSV9/cFS8p72vBcj+uUq
         ruoACl9jUod3RDrNsC+uCNUO5LQF2IXJliy4V3gb0iAvGKkWwX7pW3Rw6wHcTXH5qfyO
         NXrDu/0BV9oelNrEelk4oETwgfeU1r03izHmOwaPqCtPE1gBEw5V3AK/wq1/gh1k/rjy
         IdrC/8MFU5t6K53c4LZPRfgJf8/qbeyx/RHH1bK1UcneO0xRUTTUJ0Pn0zH+XWSCPLLD
         2DxmDu28+Rt9v73VYf4ysUWmhCkVkaYl1HAXZ2+N+2Qslb1bHDNnghcT0V37xS9As/sa
         IKnA==
X-Gm-Message-State: ACrzQf29J2FXT7+it4XgejH9ihKfQKqQtg2rkpZqktFBM+ugFNe7jqte
        5fz3ayuLibHgFS0FX2Deo/mRvg==
X-Google-Smtp-Source: AMsMyM5ukMhCc5gt699DiAR8aDwJkK0ggOsEplz9NIqReSvWIrnukbiDdeVhdE9kHzE83UXqTTmtJA==
X-Received: by 2002:a17:903:2ca:b0:179:de49:4d6b with SMTP id s10-20020a17090302ca00b00179de494d6bmr7645413plk.61.1665186531160;
        Fri, 07 Oct 2022 16:48:51 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id fv8-20020a17090b0e8800b001fe2ab750bbsm2064499pjb.29.2022.10.07.16.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 16:48:50 -0700 (PDT)
Date:   Fri, 7 Oct 2022 23:48:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v5 2/7] kvm: x86/pmu: Remove invalid raw events from the
 pmu event filter
Message-ID: <Y0C63uh77IqIQWfr@google.com>
References: <20220920174603.302510-1-aaronlewis@google.com>
 <20220920174603.302510-3-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920174603.302510-3-aaronlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 20, 2022, Aaron Lewis wrote:
> If a raw event is invalid, i.e. bits set outside the event select +
> unit mask, the event will never match the search, so it's pointless
> to have it in the list.  Opt for a shorter list by removing invalid
> raw events.

Please use "impossible" instead of "invalid".  While I agree they are invalid,
because this is pre-existing ABI, KVM can't treat them as invalid, i.e. can't
reject them.  My initial reaction to seeing remove_invalid_raw_events() was not
exactly PG-13 :-)

Can you also call out that because this is established uABI, KVM can't outright
reject garbage?

> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/pmu.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 98f383789579..e7d94e6b7f28 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -577,6 +577,38 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
>  }
>  EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
>  
> +static inline u64 get_event_filter_mask(void)
> +{
> +	u64 event_select_mask =
> +		static_call(kvm_x86_pmu_get_eventsel_event_mask)();
> +
> +	return event_select_mask | ARCH_PERFMON_EVENTSEL_UMASK;
> +}
> +
> +static inline bool is_event_valid(u64 event, u64 mask)
> +{
> +	return !(event & ~mask);
> +}

As a general theme, don't go crazy with short helpers that only ever have a single
user.  Having to jump around to find the definition interrupts the reader and
obfuscates simple things.  If the code is particularly complex/weird, then adding
a helper to abstract the concept is useful, but that's not the case here.

> +
> +static void remove_invalid_raw_events(struct kvm_pmu_event_filter *filter)

s/invalid/impossible, and drop the "raw".  Making up terminology when it's not
strictly necessary is always confusing.

> +{
> +	u64 raw_mask;
> +	int i, j;
> +
> +	if (filter->flags)

If I'm reading all this magic correctly, this is dead code because
kvm_vm_ioctl_set_pmu_event_filter() checks flags

	if (tmp.flags != 0)
		return -EINVAL;

and does the somehwat horrific thing of:

	/* Ensure nevents can't be changed between the user copies. */
	*filter = tmp;

> +		return;
> +
> +	raw_mask = get_event_filter_mask();
> +	for (i = 0, j = 0; i < filter->nevents; i++) {
> +		u64 raw_event = filter->events[i];

Meh, using a local variable is unecessary.

> +
> +		if (is_event_valid(raw_event, raw_mask))
> +			filter->events[j++] = raw_event;

With the helpers gone, this is simply: 

		if (filter->events[i] & ~kvm_pmu_ops.EVENTSEL_MASK)
			continue;

		filter->events[j++] = filter->events[i];

> +	}
> +
> +	filter->nevents = j;
> +}
> +
>  int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_pmu_event_filter tmp, *filter;
> @@ -608,6 +640,8 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>  	/* Ensure nevents can't be changed between the user copies. */
>  	*filter = tmp;

Eww.  This is so gross.  But I guess it's not really that much worse than copying
only the new bits.

Can you opportunisticaly rewrite the comment to clarify that it guards against
_all_ TOCTOU attacks on the verified data?

	/* Restore the verified state to guard against TOCTOU attacks. */
	*filter = tmp;

As a full diff:

---
 arch/x86/kvm/pmu.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index d0e2c7eda65b..384cefbe20dd 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -574,6 +574,20 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 }
 EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
 
+static void remove_impossible_events(struct kvm_pmu_event_filter *filter)
+{
+	int i, j;
+
+	for (i = 0, j = 0; i < filter->nevents; i++) {
+		if (filter->events[i] & ~kvm_pmu_ops.EVENTSEL_MASK)
+			continue;
+
+		filter->events[j++] = filter->events[i];
+	}
+
+	filter->nevents = j;
+}
+
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_pmu_event_filter tmp, *filter;
@@ -602,9 +616,11 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	if (copy_from_user(filter, argp, size))
 		goto cleanup;
 
-	/* Ensure nevents can't be changed between the user copies. */
+	/* Restore the verified state to guard against TOCTOU attacks. */
 	*filter = tmp;
 
+	remove_impossible_events(filter);
+
 	/*
 	 * Sort the in-kernel list so that we can search it with bsearch.
 	 */

base-commit: a5c25b1eacf50b851badf1c5cbb618094cbdf40f
-- 

