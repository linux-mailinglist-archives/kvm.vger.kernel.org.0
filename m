Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0654E510F87
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 05:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357522AbiD0D1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 23:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350567AbiD0D0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 23:26:50 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3BE2B1A9;
        Tue, 26 Apr 2022 20:23:34 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Kp3xF0z74z4xLS;
        Wed, 27 Apr 2022 13:23:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1651029809;
        bh=XnjvLrwvW4y9J7qh4nJRdLclh3aMRKZh5WBNUhgIeEo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E4ev3FPRzpHrWUg/ygZhOxn7yDgrMdgYwaIuB0xQLkV6IDoeUGxO4Rn5lYIl2Id8S
         qtxa0gZ+EhxyTJyhjUxgW/1+XxpcxdifLVOWxDPpe+bBN5jegS424A8v1fLdvsYpqa
         /wLGu2ke3u5HmBkt8Y67AOAcHuPQE9pu9wduLvc7bjYdNMlmI60WUWy0PGhsg0kMy1
         07GNfvfbYS8X3tBgAgvRN638MiW2jegtoTMGK8O2r2n9+1hbTPVVN5IY/seYxy7deC
         vfSMHxMmmgsB17h3Gs2m3yRHERK6kQFg7HQWm2910z9BSp7iowTYw4LYF25KiV8V3S
         /v/Re7GX4Nwwg==
Date:   Wed, 27 Apr 2022 13:23:27 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Peter Gonda <pgonda@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the kvm tree
Message-ID: <20220427132327.731b35d8@canb.auug.org.au>
In-Reply-To: <20220419153423.644c0fa1@canb.auug.org.au>
References: <20220419153423.644c0fa1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/IDM=qF2qCz+YLhDGHsq9ATh";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/IDM=qF2qCz+YLhDGHsq9ATh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 19 Apr 2022 15:34:23 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the kvm tree, today's linux-next build (arm64 defconfig)
> failed like this:
>=20
> arch/arm64/kvm/psci.c: In function 'kvm_prepare_system_event':
> arch/arm64/kvm/psci.c:184:32: error: 'struct <anonymous>' has no member n=
amed 'flags'
>   184 |         vcpu->run->system_event.flags =3D flags;
>       |                                ^
>=20
> Caused by commit
>=20
>   c24a950ec7d6 ("KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES")
>=20
> In this commit, the uapi structure changes do not match the documentation
> changes :-(  Does it matter that the ABI may be changed by this commit
> (depending on the alignment of the structure members)?
>=20
> I have added the following patch or today:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 19 Apr 2022 15:25:17 +1000
> Subject: [PATCH] fix up for "KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for=
 SEV-ES"
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/uapi/linux/kvm.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index dd1d8167e71f..68ce07185f03 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -448,6 +448,7 @@ struct kvm_run {
>  #define KVM_SYSTEM_EVENT_NDATA_VALID    (1u << 31)
>  			__u32 type;
>  			__u32 ndata;
> +			__u64 flags;
>  			__u64 data[16];
>  		} system_event;
>  		/* KVM_EXIT_S390_STSI */
> --=20
> 2.35.1

I am still applying the above patch.

--=20
Cheers,
Stephen Rothwell

--Sig_/IDM=qF2qCz+YLhDGHsq9ATh
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJoty8ACgkQAVBC80lX
0Gwo4gf/f1aF8HkvpQr5NQGYClKCx9kcT4HjASqNGY9k60ZE2qmo4vnOVu0eZuSi
4klm5J1tfXE+rbxGDbNm8ibiT6JXB5NkLv+eRPTxZYsyoGaNNs6k54N29BRnRLK9
I/DHK5Bz47VjEebaO3ew8IP6YWG22wzL30Cu155sVfQG9rEAa4c/vnOtwvI13Clx
nyt2BmgRvESF+3Rv+XHxkQ4ja56VfimPgqsU2V3ufOjocsmRAQI8eP81xzKYAeUV
PxdVBOEHlmlEHnpxzy6pC2k5UIJDLVYfY5PMwBMU9n6XSHwG6XX4AP2JpXc5w2Ie
dHCxiytb7yzPjU50iydYmuYOAImfnQ==
=6NtF
-----END PGP SIGNATURE-----

--Sig_/IDM=qF2qCz+YLhDGHsq9ATh--
