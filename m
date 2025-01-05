Return-Path: <kvm+bounces-34561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BF820A018E7
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 10:46:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 289E51883A1A
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 09:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E4E1474A2;
	Sun,  5 Jan 2025 09:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JGv3NVhg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0471459F6;
	Sun,  5 Jan 2025 09:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736070365; cv=none; b=fAONqboy1raNYI61zVB7U+tPkSiOUsCzQyvDy5/znA35msQX2g62dNOi+bngasHSOcxQeV1nIRHfJwHABgMoAHShKmPAkX/Uafv2nN+oPsz2Qxg9xjjul+l+DPo5qocCrqPBLbNTNv9vGRh65k88Ngz5iwkpagLKHEJveIcbuXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736070365; c=relaxed/simple;
	bh=py7EJ2pOOPJa6fVe/1VnqtJNnTQB95rnEVf9kjS6E5U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=UKiZmyAErPxKvH1OY7AYpJkJfPbp+e6gMpupcs8ytXg9JPl6y8+PV90IUS55se6bqE91uD6r1ii6/B0Yvl2h5DmNrN4oYcByhqcOK9yTvGhuUwIKuwhDK0303BJZ3HjqIUGAkoREtK/pKYyQ6zjUbqNKx3KJkIQayB8wU+gs1HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JGv3NVhg; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5d3e6f6cf69so23413582a12.1;
        Sun, 05 Jan 2025 01:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736070361; x=1736675161; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=py7EJ2pOOPJa6fVe/1VnqtJNnTQB95rnEVf9kjS6E5U=;
        b=JGv3NVhgJEjHyEvk80Eg22RwghKZmusyRRBkkLS/pdqhOJg80UkPZU4LaThYFaQaxu
         oTQ0+z9FNsXWO2Zvr3fwDRgVp9mT0az6nsTPBjaTH30YtAz0uuhWloWSfS8sWJPDvsNy
         qQwfrhK01EuCp+HIH/wAwp5PGHCs2fOJuANw59/IwTCedzwPM2SAnTn7OfhaxEawwV+y
         5HvkEv1sRsTPBeYTSKDCnVeBotQDz95EIY+gF2UfHZhiEBPtNyVpPsDPJmmnDNuUHp8G
         bnhNWpNNcriSYspZhuk+zUNA+x2VDvGgPxsiNc7x1DYrc+KO5d0cyNb/eM6+uP5Y8Zq7
         LVxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736070361; x=1736675161;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=py7EJ2pOOPJa6fVe/1VnqtJNnTQB95rnEVf9kjS6E5U=;
        b=Eawis4NamWdG7b6LR0XU16y8rcS+ZitE2WmHqCXniyc51Hf77xB0vAdeC1XnawcMsG
         0nq7jnqKha4ItTvTRpYYrlObKckAOySd31rXhXJqxo+QMWmRbES8N40krazOZePJWTHX
         lsDQ3gQXfLeZGX+ih7AT4ygukQB07rPbCKBCm67XE/vOknIgl9zOqycdfhePx7GJBTPK
         59JN/dZdgJMWvJ33YDRlK1gI/+lbtcMT34sDrLd+OjYgh3XWEhrDLxZbPuo2Lgtk999t
         F3NWJ5e0u4TmfWYotLglZkFkFBnMe8Ysh0zvmRgW6MKqiPcmFPQYMZDKq9p+4O8DNXrN
         jW4w==
X-Forwarded-Encrypted: i=1; AJvYcCVSKpnQvs5vzPPMxoN1Oxp322ZsFB3FWAB12OcPrVbXDds+xUTFZ/IvOj9BFK+eTiatUTM=@vger.kernel.org, AJvYcCXWzUp3+d0aMwZqGPh8tPxFJwlsMvryWhh6KcnEngswtghlW3oQWVx6JJWgeHfW2EqQyn6k3dedIQseh1g7@vger.kernel.org
X-Gm-Message-State: AOJu0YxvaeU/m0IMXkh+mbV9xXruSBrPpejCsx8k2SB9c9rZGV+64ddh
	XWxvu42hr3kI71HCU7utJTxM0OlQYjrLyynO/CoTuApzDShDrN06
X-Gm-Gg: ASbGncun0HRlbzolC30UYlWJTWm6+MEmBrcohsbSM//cJg+u8Kfvdwk7VYpQDM4zXl3
	oc8BZzpXFiSzy/sYbofQOBy2vC8U8O9BpQdrvdCxPzk08tbUO15M8ZbdDdJ3LGtd/uDpfz//eMY
	H34bMBgCXvBqTlG0fiBGkiBY8h4ew18+TTigHuZ61S0zRvDUtLe+rN3VP6UYpdaqUCs7UiHukhK
	IEPSAG+JcG2QlYIgy/88DZDEC125DQj9OEAYE36prBIIgjtsajRpVFPqTrphG6Y/RGll3RI/MIk
	eaZSkvF2d/BWYzDxn9NnJpApoIE6xMYUEpgOeg==
X-Google-Smtp-Source: AGHT+IF/2GjS5apQRLc3fKZWG94mkqm9IzvA2aUJLk4YlusBg4kWvRJ6l6IKgKph3+781mexhAM+fQ==
X-Received: by 2002:a17:906:c145:b0:aa6:832b:8d76 with SMTP id a640c23a62f3a-aac2d447677mr5085745766b.12.1736070360966;
        Sun, 05 Jan 2025 01:46:00 -0800 (PST)
Received: from ?IPv6:2001:b07:5d29:f42d:6f5a:5fd3:bfb6:eaa2? ([2001:b07:5d29:f42d:6f5a:5fd3:bfb6:eaa2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0e82eb8fsm2101917566b.35.2025.01.05.01.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2025 01:46:00 -0800 (PST)
Message-ID: <710a55a508d4fb3da5aa57667fe03f5b5dd5896f.camel@gmail.com>
Subject: Re: [PATCH v2 09/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 VM/vCPU field access
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: rick.p.edgecombe@intel.com
Cc: binbin.wu@linux.intel.com, isaku.yamahata@gmail.com, 
 isaku.yamahata@intel.com, kai.huang@intel.com, kvm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 reinette.chatre@intel.com,  sean.j.christopherson@intel.com,
 seanjc@google.com,  tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 yan.y.zhao@intel.com,  yuan.yao@intel.com
Date: Sun, 05 Jan 2025 10:45:58 +0100
In-Reply-To: <20241030190039.77971-10-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On 2024-10-30 at 19:00, Rick Edgecombe wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
>=20
> Intel TDX protects guest VMs from malicious host and certain physical
> attacks. The TDX module has TD scoped and vCPU scoped "metadata
> fields".
> These fields are a bit like VMCS fields, and stored in data
> structures
> maintained by the TDX module. Export 3 SEAMCALLs for use in reading
> and
> writing these fields:
>=20
> Make tdh_mng_rd() use MNG.VP.RD to read the TD scoped metadata.

s/MNG.VP.RD/TDH.MNG.RD/

