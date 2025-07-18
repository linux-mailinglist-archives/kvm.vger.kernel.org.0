Return-Path: <kvm+bounces-52842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B365B09A10
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 05:08:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E0394A480B
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 03:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E951D5CE8;
	Fri, 18 Jul 2025 03:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TrpFSv4A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC0B17A2E3;
	Fri, 18 Jul 2025 03:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752808120; cv=none; b=INR3SU1JyShFGB6+2wN3OVEcH4n8y0jFaxgp+AcayxZsu32IWQ0FfZwFhfiKLVEtp6q4ndyNRdFWo9vTeF32iNC+hQduvLwCbu/AF+v1vE9/jgWfsXDT+vHGLJkEVaBEX/wLfQJC7vaWx8cTIwMML0a87n686cfIcaTz5D1IBRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752808120; c=relaxed/simple;
	bh=ZuOcg5SVGCFyCtl8pLbBlIoQjdtWxJDnT+ksRDlr/d0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k3dAP2EaOaNcV4W4EWCZXgUj32WaDgDHDkTN5WVb0hVbKuSx6J8V9mFtOMKE4i2b0c/O8GWB5DS1A0PO2/jWn4kQamNw8Wyp43+vvIPIgjv75/uPLdQyx6aSdy4JtmhHICP/jv2xfkznI/psIYJniIfREwcOFlhBurm4nXy+dpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TrpFSv4A; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-235ea292956so15758195ad.1;
        Thu, 17 Jul 2025 20:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752808117; x=1753412917; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9qTFhR+y2NYI+ue6IgzVayF+O7CfTXTBkStoCWaRrQI=;
        b=TrpFSv4ASCTothXhpISmeBbmVAPsIXHYgyegcGWfasfMu8CiboZqKJzIlxykDhR6Nt
         Z7H1KXDkvNoQHX6udXq5SWgq9cRFZ7MBxhB4hWhX40Mh2Pk05C1CygoX94Um289BpTf1
         dIzf2riSdF/ln4NzqSGnMTeJlB3JhTigsppO++pfw96GP4B/sy6bsEEd+txbsn/JH2Rd
         R54nuQhB656ZkAlqiEVfsJUkV9Y5zmqXOHOkyu8CF4+c9V0EoCX0E4MyU15YeTrkqWVr
         wL/X5Uzg7vhXc43FG+vQCdQ0TrW8eVbhzxAOIAFc2wHVWor0uQ/KqmkVyE+IVFsJgsHb
         21iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752808117; x=1753412917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9qTFhR+y2NYI+ue6IgzVayF+O7CfTXTBkStoCWaRrQI=;
        b=pPNKOZ6guc+ZjlRYiyhYSsKIqPGWmfB+b/QrSgooegS6lKYE3eckwu6wrD8L7Bhgxs
         43R6Xuqsw+8gJyrcQcumgru76w2QiDUQvckW0WA9x8IrMOYUGtUxn7zaeS7QITvz6xxV
         X757F04T4AUGFRqa0cYIl7FbfHE4sfbDtUHK7wpKve1YJttrpkufaz+ldlc7kDzOQvGB
         lE0hHE9VXtOjeue28cZgi4Dz9zhEc4dZG9yXnqftg5UIJRaPunDtm01A6GqfGBz4PdaK
         CDZBiDVJdzdxe/T3TJmDEUWodvUQa0peTY/n4wo5F2T0FBYI8EkdwK8j8V3o+SB/eZQ4
         CoBg==
X-Forwarded-Encrypted: i=1; AJvYcCU0UUKgUKbad4uQBVgo97YAMMetTOR7+BuMb8G3rPxNAhVpQpSPsqsKwhjqUc8VRIEHpgY=@vger.kernel.org
X-Gm-Message-State: AOJu0YziBGNckQ2HLTfxv7tJSeY6mCRAbMaJPCKnPMynidZ/B16fRgHZ
	d+imA3Ca4BOOedOmQ+HOlzCW/L4QQ3yhUa76hKlmlV0xRQrJ32pkPhxcZw5Y6twkzh98oiM+h96
	j7Zg1oVSe59wANCSebCfe0ipk33SSwoI=
X-Gm-Gg: ASbGncu2HRvULbI6BpFEui86uE9sr3GUK/2gN+4nCj6Wib4zFE4E0vRUMqBhOTVWuAb
	MrEpfM164nDGCG7GogTxewSl2kXnUNKNNAVuU3TsBOQ7qYvHEvzayXiw8xdH6vDCAxeRarm2G/p
	ofHVBpRqjxwLLxkC4Zy3A4M3T7dGZDY7X3aL5nlGHzNpPoaJMGFwUKlYC25pCqaPxccgkga1QEl
	Ln8
X-Google-Smtp-Source: AGHT+IEf5jhJXQQa2v56cx/P3iSB4mh63ZbdHJKMxov/5hFVjsv5Um5P2ZE93DJBDqhqY3/KnijE2jMlavrFVIb9Wa0=
X-Received: by 2002:a17:902:da8b:b0:235:1706:2002 with SMTP id
 d9443c01a7336-23e2551de02mr144449935ad.0.1752808116987; Thu, 17 Jul 2025
 20:08:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-31-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250709033242.267892-31-Neeraj.Upadhyay@amd.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Fri, 18 Jul 2025 11:08:00 +0800
X-Gm-Features: Ac12FXz93-TrG7aATQgB9scdjslYFg7l0mfCh9e3Qy0ag_S03jRXGzxOAjgj0ZU
Message-ID: <CAMvTesA6os01N+mQqrhx_gMqxbCrVAJVOowJmv6unGV5ZzwnYQ@mail.gmail.com>
Subject: Re: [RFC PATCH v8 30/35] x86/apic: Read and write LVT* APIC registers
 from HV for SAVIC guests
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

On Wed, Jul 9, 2025 at 11:43=E2=80=AFAM Neeraj Upadhyay <Neeraj.Upadhyay@am=
d.com> wrote:
>
> Hypervisor need information about the current state of LVT registers
> for device emulation and NMI. So, forward reads and write of these
> registers to the hypervisor for Secure AVIC enabled guests.
>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v7:
>  - No change.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>

--
Thanks
Tianyu Lan

