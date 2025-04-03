Return-Path: <kvm+bounces-42536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 36A74A79A48
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 04:57:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D762B172294
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 02:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9150418DB18;
	Thu,  3 Apr 2025 02:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DieTF/Ep"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A89EAE7;
	Thu,  3 Apr 2025 02:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743649057; cv=none; b=fYazTrk7caliBEDcXFTFZHNf7gov1cANdpcVJBuVhvGIHktIU/IlhsFxx50pHwrqH3kLfAuvwRjwvT8meOLdJR+ijkUHyAKaFf/AYEWvUH7+lOFjk4sjLho6BEqTk3RNmwKUJKEQHYEjTZ8Ft8siIbaxz72f0bZvvg8drB9bzss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743649057; c=relaxed/simple;
	bh=8jb4V8XkZUqlpcbhZagi7ISJn/Fv0y6IQo1teX6kCAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F6Qx8VXui3giqEx+r3zYW7IsR/yFiVTunlvmEWXgfN9oY7k9HwYbyTZHeNZG3JeBnfbVT7GtOuOVmXXgNelmNmbdF+nydQBe3CbXdZ3xL8lKWSQ78vNjMFEz9dyW3Dlj+n11Plikm3bwsMiNa14uHbCoD4PEr5taswnsQJ+KEJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DieTF/Ep; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-72d3b48d2ffso427633b3a.2;
        Wed, 02 Apr 2025 19:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743649054; x=1744253854; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p3BoqPPNW09oCCD23FbwnYtde0Z+JqLbfHU8IDNJFkQ=;
        b=DieTF/EpEgVbBDDqQhP2F4xeK4HRFLOca1CDTJtc+/zNG8bHc6S8ph+OORBqrI0MGS
         SRLAGcKfPLzEGTeL9SfJpogmfQSmtn++UklcWSQE3QqeC1pfb+Kj+/Mlm7apbeYaC3C3
         cUCrZFHCKgH+TeS33QlqrlFI86lmPm5YcAOH3Wb5hIA+bLQ3bzsNwBDPD3xgE7KcPpD6
         yvqIEdENr6Mu27+vaa/xv+o00SvpdGIWikEN1VMjrOTGVSvuK6tneP4RZtkTVYBTD0PH
         KNG/sNkCwBd0OmQsaIs9HNGTodzX3LB8iwh7st5Os0yAkvtCsMjooQ4MPH3/Ub9MTJoH
         9NTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743649054; x=1744253854;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p3BoqPPNW09oCCD23FbwnYtde0Z+JqLbfHU8IDNJFkQ=;
        b=YWK/7gId7IWpnQ8L4Uy/nLvbO6Eg/Xxw2PqTujcesqFSRsOYo7stznNKZST1AaYS29
         r46QTnn6swHUCJu5o7VwWlEO07TC3M7+/vrzpXoE14iCrPTodpALlOr+0RmKmG95eTtK
         s0rwHyhjxq57Iigw5Y4wNWCnHIn//W8fN1yGpM1cDic3ighDU7mdAaBjRrLhsNCQPPGB
         ffTBVIY+PPXV07EfXqOSTGIbTI8KB94DxNQo32yPcJFU+dhm9tO1SaerCJcvRtmQVEJR
         mUfPBOc4hNOOHK9DeTFk4zMCn0CCIqGqcyh0bOQOMqdeL3jBoMmldfOPZY5Kbdv4qSpz
         dipA==
X-Forwarded-Encrypted: i=1; AJvYcCX8GLdQdsid/We9h2+LrNvg8PVW1iYH5+aLr7TsHsM8BBAtgPczMiHWIynZ8LUeKHdDVbA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxn+vtMBcuPnpK+zxngRe9QbjshCj0cJc7EWY6EDWX35ymK4Axs
	H+1E8J5tovQdqXn7pdy+Y42bP/cZ0th3rs1GvJTwwxUCGpoaUv85
X-Gm-Gg: ASbGncsJO9EhjnH2n1F3E+EgOoIe9HW1bsG9LaaJWe+RXWxLsKT55TAyYO6vCXFM55j
	5H9OxnA1RaEhhE0msRweUF9Imusol3+o1q6CtbVbC0Q4qgF2h5zkblSUEXjH7wy0J0rQehzyD8C
	wClXLirQrX0btbvMkkD/RAV5trTHHwZufhDcpKvzltQOX1ShqL3iaAwCxexuCJ006c1vqBYW1Ae
	vnnFhXFwhil2ZeEw/s1Y7NAdLuC3Ctkmd4EJCrXe/XLyohVUC5Txohd5829VIyjKou0AIHdNs5m
	yU77dfzAn+9Ni0pI3r52HUaYGhr+WP8DPFScpe5ViE1G
X-Google-Smtp-Source: AGHT+IH7xdp9zsLsuHg7UcHm2FUx/3VcJC5El8yFb4UnW2K71/Pfvu9iRctV2XHQnF6tyXNgsY6W0w==
X-Received: by 2002:a05:6a00:2d8e:b0:736:6ecd:8e34 with SMTP id d2e1a72fcca58-739d85c3342mr1305689b3a.18.1743649054268;
        Wed, 02 Apr 2025 19:57:34 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-739d97ee601sm309000b3a.48.2025.04.02.19.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 19:57:33 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 082684208F7B; Thu, 03 Apr 2025 09:57:29 +0700 (WIB)
Date: Thu, 3 Apr 2025 09:57:29 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, amit@kernel.org, kvm@vger.kernel.org,
	amit.shah@amd.com, thomas.lendacky@amd.com, bp@alien8.de,
	tglx@linutronix.de, peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 6/6] x86/bugs: Add RSB mitigation document
Message-ID: <Z-35GYpMU0GJ5Z6j@archie.me>
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <d6c07c8ae337525cbb5d926d692e8969c2cf698d.1743617897.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Vthr334gw0e4SDNm"
Content-Disposition: inline
In-Reply-To: <d6c07c8ae337525cbb5d926d692e8969c2cf698d.1743617897.git.jpoimboe@kernel.org>


--Vthr334gw0e4SDNm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 02, 2025 at 11:19:23AM -0700, Josh Poimboeuf wrote:
> +    Note that some Intel CPUs are susceptible to Post-barrier Return
> +    Stack Buffer Predictions (PBRSB)[#intel-pbrsb]_, where the last CALL
> +    from the guest can be used to predict the first unbalanced RET.  In
> +    this case the PBRSB mitigation is needed in addition to eIBRS.

I get Sphinx unreferenced footnote warning:

Documentation/admin-guide/hw-vuln/rsb.rst:221: WARNING: Footnote [#] is not=
 referenced. [ref.footnote]

To fix that, I have to separate the footnote:

---- >8 ----
diff --git a/Documentation/admin-guide/hw-vuln/rsb.rst b/Documentation/admi=
n-guide/hw-vuln/rsb.rst
index 97bf75993d5d43..dd727048b00204 100644
--- a/Documentation/admin-guide/hw-vuln/rsb.rst
+++ b/Documentation/admin-guide/hw-vuln/rsb.rst
@@ -102,7 +102,7 @@ there are unbalanced CALLs/RETs after a context switch =
or VMEXIT.
 	at the time of the VM exit." [#intel-eibrs-vmexit]_
=20
     Note that some Intel CPUs are susceptible to Post-barrier Return
-    Stack Buffer Predictions (PBRSB)[#intel-pbrsb]_, where the last CALL
+    Stack Buffer Predictions (PBRSB) [#intel-pbrsb]_, where the last CALL
     from the guest can be used to predict the first unbalanced RET.  In
     this case the PBRSB mitigation is needed in addition to eIBRS.
=20
Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--Vthr334gw0e4SDNm
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZ+35EgAKCRD2uYlJVVFO
o9/gAQCqoWK4zcdHIqqsmVjYK3VSGR9Ma0vT5fEDQM/vBa2FGgEAnBkyobxju0X2
IG/L2mIqeJDvICypkkcH/f/LixkOLwU=
=MU3h
-----END PGP SIGNATURE-----

--Vthr334gw0e4SDNm--

