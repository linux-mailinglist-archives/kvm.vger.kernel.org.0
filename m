Return-Path: <kvm+bounces-52832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03428B099B0
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 04:15:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A00A4A47328
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 02:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8043C19067C;
	Fri, 18 Jul 2025 02:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SnbVS/i2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576A43597A;
	Fri, 18 Jul 2025 02:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752804934; cv=none; b=kfQwOt2l0wcOtqi6/HvjwpuHA4OP5s9l3YjTcd2ddSzQEZSeKPxhiT1qqcmmivODKHi1MJIYBEGuvs1Zr/sJrptSxDV54GV0vcAbixotXHb1LCCVLbRtmDkU7dsqzlB0PrDsSNHVAGnfU3UG6fN2YZM4yRlkSUZ0nj9OG5nkMcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752804934; c=relaxed/simple;
	bh=lVHWpjgrHfaaSWR03iDj35NiFPjPMwhsuwBitStBHaI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZdEQDzeb4vQ7ecc7xN7KWmAUqhBSPeZsQ7kbbL9ZxurjncHJ7gwP0aoi0uRB/idhSMk5AMcE7zguXMstIC4toURKSG4LeX2Fl3L2QJKz1rejmPt2eDT06cGxbrEociIRS82dNwQAiEqN2NJtjNwK6Ax2YCncmdVPw2aD6hTt2ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SnbVS/i2; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b2c4e46a89fso1218801a12.2;
        Thu, 17 Jul 2025 19:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752804933; x=1753409733; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WWlEUDGBKmoJoMq2kVDXDpu9PhO5j92+uYIkA1+OTaQ=;
        b=SnbVS/i2Gs8vJeCdTqyeAxQSTkq0WxNtpmSKhjBCXEu+R3jzv2Gn9s9crg7wvFClSb
         LeCRkTo+6xFrKF3z+e4gVJL2lqO+BLpyz/B8UJ4Ya2qtPkybA/cJMoveZgDnNvj9SsVN
         P9HbJL3Vif9JhnKixt8cgB37QmcDHJwrmPiLyxQoA04tTmLAd6CzAz5j70TK31YxUjcF
         yQSJGedB8iQRohvwU2zN60FdCTwX2pH4O47f/XAnvR7tgF0oPD+agSg2+apkjsH0N7Tt
         aZefbfBpz3IMFj51TxygAX8pfXaGr1hoXRW5iIv2g9VqJzlnE5lw+nG1iwxzaYIBCuM6
         flkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752804933; x=1753409733;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WWlEUDGBKmoJoMq2kVDXDpu9PhO5j92+uYIkA1+OTaQ=;
        b=OaxwSpQmgXYb7FHaOBAbX2KUiKVlDqlMZ0P6RbdfwDeYtcZFNMoLE2MRjGWvKpGdVw
         Z6OloheDFBfLZOkc2RGFXlaYq1syQ7FaxFauoYtwpKj3eQ8aKw6VKflHrp334tW16K/K
         PYwe4FzXLfRsR2/bpE8JqiaJmJqL4cjgh0UxwpWMcsKyIEPyPHnPmtDck81dWpmOoJGZ
         ZIwmDIo4IAfMKCfEQh4LPpa346uAweqYuyOOtUdFcYgENDnnbGY2SC3eeUSp70Mbdi5i
         jzST1ENltwcxaSR8W9XfiemQ7FrTh1WwkEPBxgiRtrRpmTeO2l7yjI2/cPZwgFhGVsPm
         fV3w==
X-Forwarded-Encrypted: i=1; AJvYcCXbcCEo07ZDnVf75leUSS3xztpjZBImFnAWfrSPCa/kihV+jOF/fsfUkgabRjRCvDvnVfc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBRPeXaPnzhyLVrsfBnrQepVADTKjKyIXymz7KT00LFb0E323N
	STf4rbNuSNvojp/DzN4C+glYfpylg5Tx3Tj3HaPADl+e37Q5nZLihZ8iC/+AmmInmTxzmPNj5hx
	yUdsUXVbS8Cq4ESJhPG4skZCGhKsVk6A=
X-Gm-Gg: ASbGncv/CbIvBa1BCDklzNA6y3vw9Q0ev5x2qarRJIFOUW7QGapomFA70zUbZx11WP5
	PQPAs++Da1+JZjPAJB8atKFRWE/qgdGLui/g6sHBIhWhvMbyaWhFu26JjxXfbs5FUZqS1vJG9sF
	zsVSKAayvXxfkGrLQ53GSh1ij8ufsHBv/MpApvg34nLz5YL142rHRmDjzsPBkqC1ZLTnmrBL+Tq
	49in7jrWOAsi08=
X-Google-Smtp-Source: AGHT+IFWdZVlTl88oEkKWXdskwBLZOiN3Fdk4Hj0vV6hvasLjU8N4elJwG7L6YbeRTm+lXtAw5ze3lz5zfCFcykOff8=
X-Received: by 2002:a17:90b:5385:b0:311:c939:c851 with SMTP id
 98e67ed59e1d1-31c9f3c3635mr12504426a91.4.1752804932592; Thu, 17 Jul 2025
 19:15:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-26-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250709033242.267892-26-Neeraj.Upadhyay@amd.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Fri, 18 Jul 2025 10:14:54 +0800
X-Gm-Features: Ac12FXzcjNVIh8_Bpj66iqPrxKzICtwa0qE0lMBWTJuBGNQ1LXDlZ3eXFBep_DM
Message-ID: <CAMvTesB_YL7iOQdmgXDV+--c5xSh+ZDc9PwAi8_fzx12n-D0-g@mail.gmail.com>
Subject: Re: [RFC PATCH v8 25/35] x86/apic: Support LAPIC timer for Secure AVIC
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com, 
	kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com, 
	naveen.rao@amd.com, kai.huang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 9, 2025 at 11:42=E2=80=AFAM Neeraj Upadhyay <Neeraj.Upadhyay@am=
d.com> wrote:
>
> Secure AVIC requires LAPIC timer to be emulated by the hypervisor.
> KVM already supports emulating LAPIC timer using hrtimers. In order
> to emulate LAPIC timer, APIC_LVTT, APIC_TMICT and APIC_TDCR register
> values need to be propagated to the hypervisor for arming the timer.
> APIC_TMCCT register value has to be read from the hypervisor, which
> is required for calibrating the APIC timer. So, read/write all APIC
> timer registers from/to the hypervisor.
>
> Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v7:
>  - No change.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>
--
Thanks
Tianyu Lan

