Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93809508268
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 09:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236324AbiDTHnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 03:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344927AbiDTHmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 03:42:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31DFC3B;
        Wed, 20 Apr 2022 00:39:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A20921F380;
        Wed, 20 Apr 2022 07:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1650440388; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rM682Lb8fL2UKkPcEluwR0jk2UCL0AHARXD1NFlbBT8=;
        b=Vjx06ThO0pWHrtZMr22S/MUv2hJlclIicyggZcMaY79YgR5M1zIVQQDVXNGXIbL8eNgZg2
        eRL6tM1NEaG0Bc6fMm4PuBysZIzRAeUjl+uPGS16EzqQXYVsnfziJ3r39MWVZPdBbeLRNj
        wqFSbWQ0pOp/NvqfUm0MLh/kZAYq/QY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1650440388;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rM682Lb8fL2UKkPcEluwR0jk2UCL0AHARXD1NFlbBT8=;
        b=iXz7L2KFlQ/KhDZ5gVRti02zPis9oWyvm0JMGfY6/g+0bjx+LlNeCAPoSUJoE5wlWBhxjY
        rQpq6Qp1v80sTDCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 61D3F13A30;
        Wed, 20 Apr 2022 07:39:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NeuwFsS4X2J9XwAAMHmgww
        (envelope-from <vkarasulli@suse.de>); Wed, 20 Apr 2022 07:39:48 +0000
Date:   Wed, 20 Apr 2022 09:39:47 +0200
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, jroedel@suse.de, kvm@vger.kernel.org,
        bp@alien8.de, x86@kernel.org, thomas.lendacky@amd.com,
        varad.gautam@suse.com
Subject: Re: [PATCH v6 2/4] x86/tests: Add tests for AMD SEV-ES #VC handling
 Add KUnit based tests to validate Linux's VC handling for instructions cpuid
 and wbinvd. These tests: 1. install a kretprobe on the #VC handler
 (sev_es_ghcb_hv_call, to access GHCB before/after the resulting VMGEXIT). 2.
 trigger an NAE by executing either cpuid or wbinvd. 3. check that the
 kretprobe was hit with the right exit_code available in GHCB.
Message-ID: <Yl+4w1OK9E7+qRqP@vasant-suse>
References: <20220318094532.7023-1-vkarasulli@suse.de>
 <20220318094532.7023-3-vkarasulli@suse.de>
 <Ykzrb1uyPZ2AKWos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ykzrb1uyPZ2AKWos@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mi 06-04-22 01:22:55, Sean Christopherson wrote:
> The shortlog and changelog are all messed up.  Ditto for the other patches in this
> series.

I am really sorry about that. I had sent another mail with the same patch version
with subject line corrected.
https://lore.kernel.org/kvm/20220318104646.8313-1-vkarasulli@suse.de/T/#t
>
> On Fri, Mar 18, 2022, Vasant Karasulli wrote:
> > Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
> > ---
> >  arch/x86/tests/Makefile      |   2 +
> >  arch/x86/tests/sev-test-vc.c | 114 +++++++++++++++++++++++++++++++++++
> >  2 files changed, 116 insertions(+)
> >  create mode 100644 arch/x86/tests/sev-test-vc.c
>
> ...
>
> > +int sev_es_test_vc_init(struct kunit *test)
> > +{
> > +	int ret;
> > +
> > +	if (!cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT)) {
> > +		kunit_info(test, "Not a SEV-ES guest. Skipping.");
> > +		ret = -EINVAL;
> > +		goto out;
> > +	}
> > +
> > +	memset(&hv_call_krp, 0, sizeof(hv_call_krp));
> > +	hv_call_krp.entry_handler = hv_call_krp_entry;
> > +	hv_call_krp.handler = hv_call_krp_ret;
> > +	hv_call_krp.maxactive = 100;
> > +	hv_call_krp.data_size = sizeof(unsigned long);
> > +	hv_call_krp.kp.symbol_name = "sev_es_ghcb_hv_call";
> > +	hv_call_krp.kp.addr = 0;
> > +
> > +	ret = register_kretprobe(&hv_call_krp);
> > +	if (ret) {
> > +		kunit_info(test, "Could not register kretprobe. Skipping.");
> > +		goto out;
> > +	}
> > +
> > +	test->priv = kunit_kzalloc(test, sizeof(u64), GFP_KERNEL);
>
> Allocating 8 bytes and storing the pointer an 8-byte field is rather pointless :-)

Yes, I will remove this in the next version.
>
> > +	if (!test->priv) {
> > +		ret = -ENOMEM;
> > +		kunit_info(test, "Could not allocate. Skipping.");
> > +		goto out;
> > +	}
> > +
> > +out:
> > +	return ret;
> > +}
> > +
> > +void sev_es_test_vc_exit(struct kunit *test)
> > +{
> > +	if (test->priv)
> > +		kunit_kfree(test, test->priv);
> > +
> > +	if (hv_call_krp.kp.addr)
> > +		unregister_kretprobe(&hv_call_krp);
> > +}
> > +
> > +#define check_op(kt, ec, op)			\
> > +do {						\
> > +	struct kunit *t = (struct kunit *) kt;	\
> > +	op;					\
> > +	KUNIT_EXPECT_EQ(t, (typeof(ec)) ec,	\
> > +		*((typeof(ec) *)(t->priv)));		\
> > +} while (0)
> > +
> > +static void sev_es_nae_cpuid(struct kunit *test)
> > +{
> > +	unsigned int cpuid_fn = 0x8000001f;
> > +
> > +	check_op(test, SVM_EXIT_CPUID, native_cpuid_eax(cpuid_fn));
>
> Are there plans to go beyond basic checks?  Neat idea, but it seems like it will
> be prone to bitrot since it requires a somewhat esoteric setup and an opt-in config.
> And odds are very good that if the kernel can make it this far as an SEV-ES guest,
> it's gotten the basics right.

I will definitely think about adding more checks and performing these checks
early enough in the guest run.

Thanks for your feedback.

Thanks,
Vasant Karasulli
Kernel generalist
www.suse.com<http://www.suse.com>
[https://www.suse.com/assets/img/social-platforms-suse-logo.png]<http://www.suse.com/>
SUSE - Open Source Solutions for Enterprise Servers & Cloud<http://www.suse.com/>
Modernize your infrastructure with SUSE Linux Enterprise servers, cloud technology for IaaS, and SUSE's software-defined storage.
www.suse.com

