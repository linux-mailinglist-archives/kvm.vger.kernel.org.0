Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A51689C2C
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 15:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbjBCOtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 09:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbjBCOtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 09:49:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F9991187
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 06:49:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79C1261F45
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 14:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DA9C433D2;
        Fri,  3 Feb 2023 14:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675435750;
        bh=t52WNbigMsu1xdZ9Xsrfgwd5bZv6hgeD/DpkiTQjQjk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hv/zdG/mrzVzwPHwFNAMrfOEyD1QqzfVCGct2zQit8OdBQSprEyAHWt2DJOA4KOWT
         gptShfk4rLUJ/GP7nGWK9et+KyrpbYJwoT0LFY+g9RXecNmq3zxAdRhTH/lTRw1TXB
         PzX9lKZyjxCKKGB5bJmz+9ZgpDHX7apXUi+p+dyDFq03V7kvCMfCbkSTlIfl3GdeMg
         TfIOeCr6LdsiQef2bGUPP2of0/hyn9oNj2fRnCMmC3C88vVn4StsJ82KXrUjzQrRh+
         qoYV9RKLLicQkr0MqdzVUxPUiYujodmeCGjqjRf2bTBVqNAsdzlV9PKNPFrOyVZjCI
         /2V/4Dc0qpITA==
Date:   Fri, 3 Feb 2023 14:49:04 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v10 00/14] KVM: selftests: Add aarch64/page_fault_test
Message-ID: <Y90e4IluvCYSnShh@sirena.org.uk>
References: <20221017195834.2295901-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Wp5b5pNXdJZ10V7t"
Content-Disposition: inline
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
X-Cookie: Colorless green ideas sleep furiously.
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Wp5b5pNXdJZ10V7t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 17, 2022 at 07:58:20PM +0000, Ricardo Koller wrote:
> This series adds a new aarch64 selftest for testing stage 2 fault handling
> for various combinations of guest accesses (e.g., write, S1PTW), backing
> sources (e.g., anon), and types of faults (e.g., read on hugetlbfs with a
> hole, write on a readonly memslot). Each test tries a different combination
> and then checks that the access results in the right behavior (e.g., uffd
> faults with the right address and write/read flag). Some interesting
> combinations are:

I'm seeing issues with the page_fault_test tests in both -next and
mainline all the way back to v6.1 when they were introduced running on
both the fast model and hardware.  With -next the reports come back as:

# selftests: kvm: page_fault_test
# ==== Test Assertion Failure ====
#   aarch64/page_fault_test.c:316: __a == __b
#   pid=851 tid=860 errno=0 - Success
#      1	0x0000000000402253: uffd_generic_handler at page_fault_test.c:316
#      2	0x000000000040be07: uffd_handler_thread_fn at userfaultfd_util.c:97
#      3	0x0000ffff8b39edd7: ?? ??:0
#      4	0x0000ffff8b407e9b: ?? ??:0
#   ASSERT_EQ(!!(flags & UFFD_PAGEFAULT_FLAG_WRITE), expect_write) failed.
# 	!!(flags & UFFD_PAGEFAULT_FLAG_WRITE) is 0
# 	expect_write is 0x1
not ok 6 selftests: kvm: page_fault_test # exit=254

(addr2line seemed to be not doing much, I've not poked too hard at
that).  I've been unable to find any case where the program passes.
Is this expected?

Some random full runs on hardware:

4xA53: https://lava.sirena.org.uk/scheduler/job/244678
4xA72: https://lkft.validation.linaro.org/scheduler/job/6114427

--Wp5b5pNXdJZ10V7t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmPdHt8ACgkQJNaLcl1U
h9DHpgf/SSO7Y9qBYH/EO0C504/xjrEXbYwmL/VfTQ4PylF1AWCcorRiDlfVyaAd
//4RErLun4RDmVH+qH7cZenIop3gUDG6rXINxwVdlqy2tkvHQzynEQ9a/PhB7ptz
ZtIM1hV02RMfIvtd4nGP5yzRiz5jUpdzjbKE4bXXfeo66IX+aFyKMSdbZel7Atas
vSehH7PRAwgxfmzTFTcyTomDSfnS6XzwPLw1PEP1i28EtwG78/7SE9BszVamBqjE
xYsUxwhuolk3nE868Y+TucUs+oQicSDiP3C4+/8NbcHMwN1cO/WMRCwCeSb5d1GV
grGQNh47n/UE8Se0CLc4tpBOz/GU/Q==
=DlC0
-----END PGP SIGNATURE-----

--Wp5b5pNXdJZ10V7t--
