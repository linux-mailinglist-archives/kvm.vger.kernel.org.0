Return-Path: <kvm+bounces-57284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E427B52B12
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 10:03:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E20127B4FD4
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 07:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421F62D541B;
	Thu, 11 Sep 2025 08:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OZFq1eLJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2EC2D5925
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 08:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757577610; cv=none; b=okebwprDFI5f1gVzd9EkupABM5JU/ZZ4CmCM/QpJBnOAU6zOk4rBCnbFSvcVH6Y65B7CEf+GcqLMDnY/4xESvOu+6hVvPbRVPGjPI1QZn9WuqxOR9vxovlpZSgxCWXxFnxpKONCSkkuJSGPT1fTQ7EEERhNrqUehMTgMZbFGPqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757577610; c=relaxed/simple;
	bh=QrlNksX0kBZBWgevQvqTCUnuhFgrLUFmsGDLIooJuIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BbInMg41f3OMgmUSrnYCT3KiUZhowkLaRYJDK3ow2K3PjmMgGBpCTzaxRJRpG8T1SJaN/LlJZB3iWVrUZvaflrDpaHl5PEXDV5HUihq+d77HovIIpJ4lQEyIrV80jrlEBQgK6WEGRhWEsTYlWjUVQfWMWaxHATs3xzgqwReS3m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OZFq1eLJ; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6228de280ccso847741a12.3
        for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 01:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757577606; x=1758182406; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QrlNksX0kBZBWgevQvqTCUnuhFgrLUFmsGDLIooJuIw=;
        b=OZFq1eLJ5zdQ+Q+m0ma0ndU16/jQL9p3ynWRQMCzUs9NNtvsQgeLSq9KuxgkGrjEGi
         EfU2ROq/pt35D2R2tB2N1VN7Ta8aXRabVomks8d0WukEYYdjr6jE6Dv/ioCibaie8SXp
         Eoybw2JZW5nKHviwRn6mR8aSOxvqs4SzphHMeL4Wksr9mqBgc7In5ewX6oETFUrcG+HF
         1nVhqqLyhkRFhxLJdrL+y+fAgleUS9s5N8CtDntVFIKSOm8r5hqAuSqr1dHa6Bcwi8kT
         5Gtf17cSG+lfnTwaX4hchHu0OHFaPNbxLyAA4JYyNVaJrTtTWNHdd3ScUaAmf62JPX0D
         V59Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757577606; x=1758182406;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QrlNksX0kBZBWgevQvqTCUnuhFgrLUFmsGDLIooJuIw=;
        b=aiprqZNIJrzm7vTxKU5TRTW6ItX12HiG01q/Ez5OfEegqpJq1HmaLqSJYgmxg2cyy4
         qP+/b6Dj2BFVlQcJhqD5oM+TuvI0r6Yoe20NHvX0ymYGPA4BB1ropy2YF7ilpbW3WfDa
         /cBXZmJRDYPWlv0k225CTveq5bkuVXsjbZvdHwm/f+8N7GLXS6BNpFvj2JWOOPOVGs00
         e/y9am7EgwdAL/Ayd0bP+DdKC9wUgptHvlCco6ZEQqPNepBUfPqxfU4oloTdw6Zo2k+Y
         fsYRrcA+nzriF3DL4nFPwsfBZcmuVdLQW5ioD+oyXI6VsXyPhDEtiv5WuwLCSzhJyxF3
         DKcw==
X-Forwarded-Encrypted: i=1; AJvYcCVRHDf4+m4Mo6jYjaJCUTkqdaRJO9DEedppAK3hK5bxhp9md0rXmtFviYe6k51VFiPbTko=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCvmWvgs4k1QMYTrs+1/zos1X34YFH03dTP/3bnYK8LAi7u4j3
	n+X9aR09O1yfNaNoEcrkLrtcHtS7MS+myfTAOTKnaAZKp5kWIsj9q8X7P3XdRcSmFHs=
X-Gm-Gg: ASbGncuoayChLAUzLXLceRzmbjE0szuAaYCzLk8RJfx8nQSa1FKtRLmM6wW3WdmtfFY
	ZhXlR4TG5wbKJDxETIcVGslsMPY7q2MCRnlB3oJ8neeJiKGTlxfkwiD3iTYvzb8WFY0UMjLduMY
	OiQhnmD3c432panVLiale3d2OH+l976k9f1BWmSgLz4xj+yKEirq84TkrfIIlq+WWRcQQnYV5P9
	KH2p1QqoewVFq7YXW1TAOBAmxnBel/ISNKlA95PEyxj7ure8Lrq4qleRWaR+YGhpgfEW79c2Kjh
	xm4Cdu74sitDJddVZQ1i6u4ZUTiSdBef0Yn7gkCuT063iwZlwkU0dyFCSzy0lOoiYCfTOZ+T7ZL
	pOEgw8iuB/X6AicLPxC7o2tKJ4uWETCIjbd3QgaDQrJuMW05dH16QFOh8NrG+zz2cYOZbVxEI4U
	fq8QM3O/1bWW0X2wH1tG03Zwlil3ixP5HSbRh0t1c2nnEgmQhYVIw95OM=
X-Google-Smtp-Source: AGHT+IHtwJP+NpH1ymNM/0dCe30VtYrs+73DFAhA7FZXocgko07f9smiOVMlJT1b7qw2DXXLesjZRA==
X-Received: by 2002:a05:6402:50c8:b0:62e:c525:4f94 with SMTP id 4fb4d7f45d1cf-62ec5255575mr672136a12.32.1757577606313;
        Thu, 11 Sep 2025 01:00:06 -0700 (PDT)
Received: from ?IPV6:2003:e5:873d:be00:c26:b971:1ba7:9d8b? (p200300e5873dbe000c26b9711ba79d8b.dip0.t-ipconnect.de. [2003:e5:873d:be00:c26:b971:1ba7:9d8b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62ec3410ee7sm644477a12.50.2025.09.11.01.00.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 01:00:05 -0700 (PDT)
Message-ID: <eb760054-1679-408a-9de9-2505f88382dd@suse.com>
Date: Thu, 11 Sep 2025 10:00:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/14] paravirt: cleanup and reorg
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
 Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Will Deacon <will@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
 Jiri Kosina <jikos@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Russell King
 <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Daniel Lezcano <daniel.lezcano@linaro.org>
References: <20250911063433.13783-1-jgross@suse.com>
 <20250911074817.GX3245006@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <20250911074817.GX3245006@noisy.programming.kicks-ass.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------qqcArw2UNkNKESBZAhTAYfh4"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------qqcArw2UNkNKESBZAhTAYfh4
Content-Type: multipart/mixed; boundary="------------SW0CtEgoDQ04mHi3OOJ80Cxj";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
 Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Will Deacon <will@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
 Jiri Kosina <jikos@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Russell King
 <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <eb760054-1679-408a-9de9-2505f88382dd@suse.com>
Subject: Re: [PATCH 00/14] paravirt: cleanup and reorg
References: <20250911063433.13783-1-jgross@suse.com>
 <20250911074817.GX3245006@noisy.programming.kicks-ass.net>
In-Reply-To: <20250911074817.GX3245006@noisy.programming.kicks-ass.net>

--------------SW0CtEgoDQ04mHi3OOJ80Cxj
Content-Type: multipart/mixed; boundary="------------uLSRgxz23yDirGsh3b5wzau0"

--------------uLSRgxz23yDirGsh3b5wzau0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTEuMDkuMjUgMDk6NDgsIFBldGVyIFppamxzdHJhIHdyb3RlOg0KPiBPbiBUaHUsIFNl
cCAxMSwgMjAyNSBhdCAwODozNDoxOUFNICswMjAwLCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0K
Pj4gU29tZSBjbGVhbnVwcyBhbmQgcmVvcmcgb2YgcGFyYXZpcnQgY29kZSBhbmQgaGVhZGVy
czoNCj4+DQo+PiAtIFRoZSBmaXJzdCAyIHBhdGNoZXMgc2hvdWxkIGJlIG5vdCBjb250cm92
ZXJzaWFsIGF0IGFsbCwgYXMgdGhleQ0KPj4gICAgcmVtb3ZlIGp1c3Qgc29tZSBubyBsb25n
ZXIgbmVlZGVkICNpbmNsdWRlIGFuZCBzdHJ1Y3QgZm9yd2FyZA0KPj4gICAgZGVjbGFyYXRp
b25zLg0KPj4NCj4+IC0gVGhlIDNyZCBwYXRjaCBpcyByZW1vdmluZyBDT05GSUdfUEFSQVZJ
UlRfREVCVUcsIHdoaWNoIElNTyBoYXMNCj4+ICAgIG5vIHJlYWwgdmFsdWUsIGFzIGl0IGp1
c3QgY2hhbmdlcyBhIGNyYXNoIHRvIGEgQlVHKCkgKHRoZSBzdGFjaw0KPj4gICAgdHJhY2Ug
d2lsbCBiYXNpY2FsbHkgYmUgdGhlIHNhbWUpLiBBcyB0aGUgbWFpbnRhaW5lciBvZiB0aGUg
bWFpbg0KPj4gICAgcGFyYXZpcnQgdXNlciAoWGVuKSBJIGhhdmUgbmV2ZXIgc2VlbiB0aGlz
IGNyYXNoL0JVRygpIHRvIGhhcHBlbi4NCj4+DQo+PiAtIFRoZSA0dGggcGF0Y2ggaXMganVz
dCBhIG1vdmVtZW50IG9mIGNvZGUuDQo+Pg0KPj4gLSBJIGRvbid0IGtub3cgZm9yIHdoYXQg
cmVhc29uIGFzbS9wYXJhdmlydF9hcGlfY2xvY2suaCB3YXMgYWRkZWQsDQo+PiAgICBhcyBh
bGwgYXJjaHMgc3VwcG9ydGluZyBpdCBkbyBpdCBleGFjdGx5IGluIHRoZSBzYW1lIHdheS4g
UGF0Y2gNCj4+ICAgIDUgaXMgcmVtb3ZpbmcgaXQuDQo+Pg0KPj4gLSBQYXRjaGVzIDYtMTIg
YXJlIHN0cmVhbWxpbmluZyB0aGUgcGFyYXZpcnQgY2xvY2sgaW50ZXJmYWNlcyBieQ0KPj4g
ICAgdXNpbmcgYSBjb21tb24gaW1wbGVtZW50YXRpb24gYWNyb3NzIGFyY2hpdGVjdHVyZXMg
d2hlcmUgcG9zc2libGUNCj4+ICAgIGFuZCBieSBtb3ZpbmcgdGhlIHJlbGF0ZWQgY29kZSBp
bnRvIGNvbW1vbiBzY2hlZCBjb2RlLCBhcyB0aGlzIGlzDQo+PiAgICB3aGVyZSBpdCBzaG91
bGQgbGl2ZS4NCj4+DQo+PiAtIFBhdGNoZXMgMTMrMTQgYXJlIG1vcmUgbGlrZSBSRkMgbWF0
ZXJpYWw6IHBhdGNoIDEzIGlzIGRvaW5nIHNvbWUNCj4+ICAgIHByZXBhcmF0aW9uIHdvcmsg
dG8gZW5hYmxlIHBhdGNoIDE0IHRvIG1vdmUgYWxsIHNwaW5sb2NrIHJlbGF0ZWQNCj4+ICAg
IHBhcmF2aXJ0IGZ1bmN0aW9ucyBpbnRvIHFzcGlubG9jay5oLiBJZiB0aGlzIGFwcHJvYWNo
IGlzIGFjY2VwdGVkLA0KPj4gICAgSSdkIGxpa2UgdG8gY29udGludWUgd2l0aCB0aGlzIHdv
cmsgYnkgbW92aW5nIG1vc3QgKG9yIGFsbD8pDQo+PiAgICBwYXJhdmlydCBmdW5jdGlvbnMg
ZnJvbSBwYXJhdmlydC5oIGludG8gdGhlIGhlYWRlcnMgd2hlcmUgdGhlaXINCj4+ICAgIG5h
dGl2ZSBjb3VudGVycGFydHMgYXJlIGRlZmluZWQuIFRoaXMgaXMgbWVhbnQgdG8ga2VlcCB0
aGUgbmF0aXZlDQo+PiAgICBhbmQgcGFyYXZpcnQgZnVuY3Rpb24gZGVmaW5pdGlvbnMgdG9n
ZXRoZXIgaW4gb25lIHBsYWNlIGFuZA0KPj4gICAgaG9wZWZ1bGx5IHRvIGJlIGFibGUgdG8g
cmVkdWNlIHRoZSBpbmNsdWRlIGhlbGwgd2l0aCBwYXJhdmlydC4NCj4+DQo+PiBKdWVyZ2Vu
IEdyb3NzICgxNCk6DQo+PiAgICB4ODYvcGFyYXZpcnQ6IHJlbW92ZSBub3QgbmVlZGVkIGlu
Y2x1ZGVzIG9mIHBhcmF2aXJ0LmgNCj4+ICAgIHg4Ni9wYXJhdmlydDogcmVtb3ZlIHNvbWUg
dW5uZWVkZWQgc3RydWN0IGRlY2xhcmF0aW9ucw0KPj4gICAgeDg2L3BhcmF2aXJ0OiByZW1v
dmUgUEFSQVZJUlRfREVCVUcgY29uZmlnIG9wdGlvbg0KPj4gICAgeDg2L3BhcmF2aXJ0OiBt
b3ZlIHRodW5rIG1hY3JvcyB0byBwYXJhdmlydF90eXBlcy5oDQo+PiAgICBwYXJhdmlydDog
cmVtb3ZlIGFzbS9wYXJhdmlydF9hcGlfY2xvY2suaA0KPj4gICAgc2NoZWQ6IG1vdmUgY2xv
Y2sgcmVsYXRlZCBwYXJhdmlydCBjb2RlIHRvIGtlcm5lbC9zY2hlZA0KPj4gICAgYXJtL3Bh
cmF2aXJ0OiB1c2UgY29tbW9uIGNvZGUgZm9yIHBhcmF2aXJ0X3N0ZWFsX2Nsb2NrKCkNCj4+
ICAgIGFybTY0L3BhcmF2aXJ0OiB1c2UgY29tbW9uIGNvZGUgZm9yIHBhcmF2aXJ0X3N0ZWFs
X2Nsb2NrKCkNCj4+ICAgIGxvb25nYXJjaC9wYXJhdmlydDogdXNlIGNvbW1vbiBjb2RlIGZv
ciBwYXJhdmlydF9zdGVhbF9jbG9jaygpDQo+PiAgICByaXNjdi9wYXJhdmlydDogdXNlIGNv
bW1vbiBjb2RlIGZvciBwYXJhdmlydF9zdGVhbF9jbG9jaygpDQo+PiAgICB4ODYvcGFyYXZp
cnQ6IHVzZSBjb21tb24gY29kZSBmb3IgcGFyYXZpcnRfc3RlYWxfY2xvY2soKQ0KPj4gICAg
eDg2L3BhcmF2aXJ0OiBtb3ZlIHBhcmF2aXJ0X3NjaGVkX2Nsb2NrKCkgcmVsYXRlZCBjb2Rl
IGludG8gdHNjLmMNCj4+ICAgIHg4Ni9wYXJhdmlydDogYWxsb3cgcHYtY2FsbHMgb3V0c2lk
ZSBwYXJhdmlydC5oDQo+PiAgICB4ODYvcHZsb2NrczogbW92ZSBwYXJhdmlydCBzcGlubG9j
ayBmdW5jdGlvbnMgaW50byBxc3BpbmxvY2suaA0KPiANCj4gV2l0aCB0aGUgbm90ZSB0aGF0
IHRpcCB0eXBpY2FsbHkgbGlrZXMgYSBjYXBpdGFsIGFmdGVyIHRoZSBwcmVmaXgsIGxpa2U6
DQo+IA0KPiAgICB4ODYvcGFyYXZpcnQ6IFJlbW92ZSB1bm5lZWRlZCBpbmNsdWRlcyBvZiBw
YXJhdmlydC5oDQoNCk5vdGVkLCB0aGFua3MuDQoNCj4gDQo+IEZvciAxLTEyOg0KPiANCj4g
ICAgQWNrZWQtYnk6IFBldGVyIFppamxzdHJhIChJbnRlbCkgPHBldGVyekBpbmZyYWRlYWQu
b3JnPg0KPiANCj4gDQo+IE5vdywgYXMgdG8gdGhlIGxhc3QgdHdvLCBJJ20gbm90IHN1cmUu
IExlYWtpbmcgdGhvc2UgbWFjcm9zIG91dCBvZiBQVg0KPiBpc24ndCBwYXJ0aWN1bGFybHkg
bmljZSwgdGhlbiBhZ2Fpbiwgbm90IHRoZSBlbmQgb2YgdGhlIHdvcmxkIGVpdGhlci4NCj4g
SnVzdCBub3Qgc3VyZS4NCg0KWWVzLCB0aGF0J3Mgd2h5IEkgZGlkbid0IGNvbnRpbnVlIHdp
dGggYWxsIG9mIHRoZSBvdGhlciBwb3RlbnRpYWwgbW92ZW1lbnQgb2YNCnBhcmF2aXJ0IGZ1
bmN0aW9ucy4gSSB3YW50IHNvbWUgZmVlZGJhY2sgZmlyc3QuIDotKQ0KDQpJdHMgYSB0cmFk
ZW9mZiBiZXR3ZWVuIGhhdmluZyBmdW5jdGlvbnMgd2l0aCAvIHdpdGhvdXQgcGFyYXZpcnQg
aW4gb25lIGZpbGUNCmFnYWluc3QgaGlkaW5nIHRoZSBwYXJhdmlydCBzdHVmZiBmcm9tICJu
b3JtYWwiIHJlYWRlcnMgKG5vdCB3cml0ZXJzLCBhcyB0aG9zZQ0KcHJvYmFibHkgbmVlZCB0
byB0b3VjaCB0aGUgcGFyYXZpcnQgdmFyaWFudCwgdG9vKS4NCg0KQlRXLCBJIHRoaW5rIHRo
ZSBtYWNybyBsZWFraW5nIGlzbid0IHRoZSBtYWluIHByb2JsZW0uIFRoZXJlIGFyZSBvdGhl
ciBtYWNyb3MNCmxlYWtpbmcgYWxyZWFkeS4NCg0KDQpKdWVyZ2VuDQo=
--------------uLSRgxz23yDirGsh3b5wzau0
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------uLSRgxz23yDirGsh3b5wzau0--

--------------SW0CtEgoDQ04mHi3OOJ80Cxj--

--------------qqcArw2UNkNKESBZAhTAYfh4
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmjCgYQFAwAAAAAACgkQsN6d1ii/Ey8r
OAf/Qr2x8nYLyGRENJrie6zcaTwNZyeK2FPaGrjzVaiWjT9VH4G2q5x5mhR5oFWV4toAblU5ow2h
SX840JnBB/J+SkC/W9J4UKM5yKPxGuiAZIyUVnryVO46qdBhemIpMn03Sq3Bij/oQn62902kMQk8
+Fav26WncSGYllLET53pleP3CiC3wO/NrpLc1gGkGJR7e6Mh9/tA4FldPiYKafGEWVvvZvRHGsrb
BK/o5327iIlO40Rj51EE+RKO8uspX4JanSFzCXXis6bGSLcJtqwYK9y4eLMEqqvTNB8h30YWROBp
6YVlChchkh9g1mcOIfBDkyiK0cKJQ9lHSBC7mBkEiw==
=k6d0
-----END PGP SIGNATURE-----

--------------qqcArw2UNkNKESBZAhTAYfh4--

