Return-Path: <kvm+bounces-27199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A1897D1E0
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 09:40:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DAED1C226F8
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 07:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1B631311B6;
	Fri, 20 Sep 2024 07:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="gmybFVbE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A4D5339F
	for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 07:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726817976; cv=none; b=qSLBd/qbY3D8BnCsKBSlXOjalvq/mWcM5/XdE9PtHa9w1GRngTdulBtzDjqoMQ1266kwWAlDnuGu8r5HU/YcnaMgwe/9wP71OXGG8SwTANx/5WqQNm6GkFybz10Azf7q1Tn0/1Pk+ieGyYX7ym32CJYO2m35FFL4i36ahqyjoSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726817976; c=relaxed/simple;
	bh=0k8ksCBEILGEf/m73awHSumKV1bg5YEQJrbmB46fqmU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rxZDkf94XJvBA7HbxGwdaIlzqYOqzhvdqGeeYjZdXgFggdmN2hP5TSY7/tC8S3fe+xgNRlb+duv7Tkn6YE84AMQVOJAZbh9boi3RdqmgD4zibjnD4b8YdulDy20jAWC1GXhl93R7VRt4jn0GSy2R5vh0GcmXPmiluGmq3CyFwak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=gmybFVbE; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3e039666812so846102b6e.1
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 00:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1726817974; x=1727422774; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ruwmjdS7i6iu2fXr/1ljeWFvjxlJAr2Uh230cCJEG48=;
        b=gmybFVbEj3JwSm+2Eanz1pwESiP9DUcvloqdUk+mQj840nOL3zlSD0rq3QW6+Wj0gn
         7hNOLzaCIE6NbkBxoW94/Qbspv8ixd60MoBEditM7bZUCZKxVj+uqPCGhV4NrCEwUKC8
         mvlnGql3Z/PS8bTuAVzPinWJBMyH0C4uXdluov9s2AdZE5SRhiJ3H+kkqlQVrco5kh7z
         q18Iva3HaKO+9YWm9dxw3932oNENVZYcALD/dlWsgjB4/Nh/mAIy+hTlF3kgkymqMIJT
         wnjLi/IvgeUwPvHXLDziRU9RwoucVvChFhcUXuQHP4nvfgK0ggfgcma3SViWSFXhCG/y
         z8hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726817974; x=1727422774;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ruwmjdS7i6iu2fXr/1ljeWFvjxlJAr2Uh230cCJEG48=;
        b=GXRdCc/W9LrvybpI1He7yVhdOKewdSA8BRrz3yGbgNF5/qt/54iDFle0X8P49kicmK
         uoNbag7Zgsk9+XfF9Y2dpLAcJOd5Zv3tJj5XlWHt0lF4qGiygDmLxpMQ6FoOhOg0SaVj
         qfW7yQMC6SDisXs8HeZEo8IY4M9jkY0tSu+gSvqpeCSKhSp3f8GQFufLS7Fa/xHFBPlR
         +NF+AK9/gYI3gZVimUiO1VX3P/R3X0WZoZphnIw6Eo8f6VhAiHT6FQ4ufXQe1MzbVsnU
         9HXpdCJAxYIKERWamwUalCIF30aeHQ+aQBk37SaWLzWas5fuRRq5ENCUkF9jUKSeU1hb
         zUCw==
X-Forwarded-Encrypted: i=1; AJvYcCWOX3pj5xiI7uUVT1l/YQFkPdz1ABx6VbqyNGQpPHSeK5/5ZRRUfq+bc8j+1HLWraZgGGE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmJbaOIF50SX5jHkGO4rwCHjX/8w2aoZO1h+rCq6t3H0UXfEM6
	yxxnwbnjX/xLwRBKapdkX0j3gNSmjJY/tZMDnM7K2Q8yDVcoPD7d21v0Djttux+vbDwcmrYeyuw
	gcHk=
X-Google-Smtp-Source: AGHT+IFQ17yTVynIy2XrD45IeMLpoJPTm7mZPtHiliv+sGkaava/UbW2FEYcKNJPThWePCcr9bME2w==
X-Received: by 2002:a17:902:f693:b0:206:c5cf:9721 with SMTP id d9443c01a7336-208d830ed04mr28068335ad.1.1726817964075;
        Fri, 20 Sep 2024 00:39:24 -0700 (PDT)
Received: from [127.0.1.1] (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-207946fcaa4sm89645805ad.212.2024.09.20.00.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2024 00:39:23 -0700 (PDT)
From: Max Hsu <max.hsu@sifive.com>
Date: Fri, 20 Sep 2024 15:39:03 +0800
Subject: [PATCH RFC 1/3] dt-bindings: riscv: Add Svukte entry
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240920-dev-maxh-svukte-rebase-v1-1-7864a88a62bd@sifive.com>
References: <20240920-dev-maxh-svukte-rebase-v1-0-7864a88a62bd@sifive.com>
In-Reply-To: <20240920-dev-maxh-svukte-rebase-v1-0-7864a88a62bd@sifive.com>
To: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>
Cc: Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Max Hsu <max.hsu@sifive.com>, Samuel Holland <samuel.holland@sifive.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1312; i=max.hsu@sifive.com;
 h=from:subject:message-id; bh=0k8ksCBEILGEf/m73awHSumKV1bg5YEQJrbmB46fqmU=;
 b=owEB7QES/pANAwAKAdID/Z0HeUC9AcsmYgBm7SalmDrzx1nt7U4zRVn2TPSNvgiS6IDu0bWQn
 Kih/ez6tBaJAbMEAAEKAB0WIQTqXmcbOhS2KZE9X2jSA/2dB3lAvQUCZu0mpQAKCRDSA/2dB3lA
 vYzBDAC4qFye9TdTtbWuZxd4jp5gc9vJmV5AkP++702TLaSmioYtypI+JvTir7sHlehq6ncb/yf
 bmnci8IxCkk1BADX4GYvx2EGMziigRvdO2ZyTCIUr4Oe6SazBRjKSHvpi6QSWiCZAyhrXMtbFhe
 h9QvCakpMYjDTpp7Xiw2vj4VfO4nILyDcQCW54ZnUMqsEvXm7Yf3lIzElrG0gFmU3wfUsfxhc64
 tQEwoVnpzClS/JFlW2tW+zaI31qv4AQ6Ntw880KMfwKu0gI8546318I7uHDl0HK5ZVO2jrt/pCF
 iRvjX1UeHaIRBYdojju8pI7yWfoHS8l8yoOSHhtJ/rpRCUsEzPgVb9lmEOofF6RgxmnK4ZbYUa0
 TjF5lJmjW+3hdk67G2oiL3DBWnp1OX3V11ciOBnWkZMTOhZLHbPAtlNZ33cYDb6zJrQxOGBqPgy
 VUmHLfSABhBVe2ryVn0D7VUjc6DOJgIl9nWifkZyuAYkCuv2SKqBunOTfIIcuVF+WdCro=
X-Developer-Key: i=max.hsu@sifive.com; a=openpgp;
 fpr=EA5E671B3A14B629913D5F68D203FD9D077940BD

Add an entry for the Svukte extension to the riscv,isa-extensions
property.

Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Signed-off-by: Max Hsu <max.hsu@sifive.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index a06dbc6b4928958704855c8993291b036e3d1a63..df96aea5e53a70b0cb8905332464a42a264e56e6 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -171,6 +171,13 @@ properties:
             memory types as ratified in the 20191213 version of the privileged
             ISA specification.
 
+        - const: svukte
+          description:
+            The standard Svukte supervisor-level extensions for making user-mode
+            accesses to supervisor memory raise page faults in constant time,
+            mitigating attacks that attempt to discover the supervisor
+            software's address-space layout, as PR#1564 of riscv-isa-manual.
+
         - const: zacas
           description: |
             The Zacas extension for Atomic Compare-and-Swap (CAS) instructions

-- 
2.43.2


