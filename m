Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911595FC983
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 18:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiJLQwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 12:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiJLQwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 12:52:23 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5922E31A7
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:52:22 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id l4so16774673plb.8
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MOsSdEMIqzmaXEJTvNGU9U8dwUA0w+tOWtkc3jQusuU=;
        b=TT5w/mmSOL4m6p27LuU5cONBfB/8vRbE57RIgnkle1+vQO6iqd041rZVu/I3DwPOxU
         zYriGzsEU/3Zfp1cKaw6OFXkKw0R0nSph2mLzxSv3FaLtu/TxSZQHUT/NapYNO1BbYBa
         ZvwWIdtqQzxBGa0PdoNwArmHmrxCRRsFTJ1Eu6yw0vRelL0392dPxmXc3RXifTD7MY7k
         /I9gQ0LghE19x27zD2SVnRBjwLqx1moAEoAA5VG1mWVnG5MbpNs4C/qKPwVEqvQoi0sB
         zKCahlOINf4UlgsMvk2OEaORL8eqyoM9myjeetPgIdktqHj1LWvsOqr/GTgeuOjo18nN
         0Zog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MOsSdEMIqzmaXEJTvNGU9U8dwUA0w+tOWtkc3jQusuU=;
        b=ACmP2L1C0jGjKTLDpjbpBi0IJZ3im0KRJRStEke/l6+Ks8Wg2HZyKKYpTWDRaIBtLC
         82Z9tCnY9tJDqjAdlWWlwFEN19QaaCSk02xck3H2jbRDHZaPMluHkyQELElmhK9BVThA
         o+VceOL9wDqfewKDpB84VDLQOM96uYhTYeQs5KzlyWms40qlPKB4IhskIH+RdcECRsVT
         MJwP17L/wtb0oDnjc8BM84frVcMuV0qqx9rykc9NXkPk2eCWfuh350tLNyhPhpzxTLCY
         kYWq6YBsvzRxGsu19IfdAYO/YRf7i+o2VAxQUOuS7ZRJgbp2Q2UuYy4FmvuQivOBmxgd
         A2nw==
X-Gm-Message-State: ACrzQf1QppnNl9lQeVB2PMoDCsZbBK7B/Qgj4ybFclfjjPbbOM65BGJT
        6C98LdgqSNvJFrxU+5rN3YUSfQ==
X-Google-Smtp-Source: AMsMyM7qJZXDgn3nv0ZoJYxXuNana0IUjpv7TwoHaQul1TAFM2JgYZO8spd6F7tXGY006EDxQnIwvQ==
X-Received: by 2002:a17:903:2594:b0:17c:6117:2434 with SMTP id jb20-20020a170903259400b0017c61172434mr31144511plb.135.1665593542028;
        Wed, 12 Oct 2022 09:52:22 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w196-20020a6282cd000000b00553d573222fsm67015pfd.199.2022.10.12.09.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 09:52:21 -0700 (PDT)
Date:   Wed, 12 Oct 2022 16:52:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/6] KVM: selftests: Test Hyper-V invariant TSC control
Message-ID: <Y0bwwfuO/iubQDPH@google.com>
References: <20220922143655.3721218-1-vkuznets@redhat.com>
 <20220922143655.3721218-7-vkuznets@redhat.com>
 <Y0XGuk4vwJBTU9oN@google.com>
 <87v8op6wq3.fsf@ovpn-194-196.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8op6wq3.fsf@ovpn-194-196.brq.redhat.com>
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

On Wed, Oct 12, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Thu, Sep 22, 2022, Vitaly Kuznetsov wrote:
> >> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> >> index d4bd18bc580d..18b44450dfb8 100644
> >> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> >> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> >> @@ -46,20 +46,33 @@ struct hcall_data {
> >>  
> >>  static void guest_msr(struct msr_data *msr)
> >>  {
> >> -	uint64_t ignored;
> >> +	uint64_t msr_val = 0;
> >>  	uint8_t vector;
> >>  
> >>  	GUEST_ASSERT(msr->idx);
> >>  
> >> -	if (!msr->write)
> >> -		vector = rdmsr_safe(msr->idx, &ignored);
> >> -	else
> >> +	if (!msr->write) {
> >> +		vector = rdmsr_safe(msr->idx, &msr_val);
> >
> > This is subtly going to do weird things if the RDMSR faults.  rdmsr_safe()
> > overwrites @val with whatever happens to be in EDX:EAX if the RDMSR faults, i.e.
> > this may yield garbage instead of '0'.  Arguably rdmsr_safe() is a bad API, but
> > at the same time the caller really shouldn't consume the result if RDMSR faults
> > (though aligning with the kernel is also valuable).
> >
> > Aha!  Idea.  Assuming none of the MSRs are write-only, what about adding a prep
> > patch to rework this code so that it verifies RDMSR returns what was written when
> > a fault didn't occur.
> >
> 
> There is at least one read-only MSR which comes to mind:
> HV_X64_MSR_EOI.

I assume s/read-only/write-only since it's EOI?

> Also, some of the MSRs don't preserve the written value,
> e.g. HV_X64_MSR_RESET which always reads as '0'.

Hrm, that's annoying.

> I do, however, like the additional check that RDMSR returns what was
> written to the MSR, we will just need an additional flag in 'struct
> msr_data' ('check_written_value' maybe?).

Rather than force the testcase to specify information that's intrinsic to the MSR,
what about adding helpers to communicate the types?  E.g.

        if (msr->write)
                vector = wrmsr_safe(msr->idx, msr->write_val);

        if (!vector && !is_write_only_msr(msr->idx))
                vector = rdmsr_safe(msr->idx, &msr_val);

        if (msr->fault_expected)
                GUEST_ASSERT_2(vector == GP_VECTOR, msr->idx, vector);
        else
                GUEST_ASSERT_2(!vector, msr->idx, vector);

	if (is_read_zero_msr(msr->idx))
		GUEST_ASSERT_2(msr_val == 0, msr_val, 0);
	else
		GUEST_ASSERT_2(msr_val == msr->write_val, msr_val, msr->write_val);

I think that'd make the code a bit less magical and easier to understand for folks
that aren't familiar with Hyper-V.  The number of special MSRs is likely very small,
so the helpers should be trivial, e.g.

static bool is_write_only_msr(uint32_t msr)
{
	return msr == HV_X64_MSR_EOI;
}

static bool is_read_zero_msr(uint32_t msr)
{
	return msr == HV_X64_MSR_RESET || msr == ???;
}
