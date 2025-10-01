Return-Path: <kvm+bounces-59237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E8CBAEFB6
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 04:06:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7811D3B069A
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 02:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40F22580F2;
	Wed,  1 Oct 2025 02:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BR6T08QP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A0C25484B
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 02:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759284356; cv=none; b=Du9nhMCDEDb9Gw8uqjPbB36GzKQJl9QqqQ6cUdixu41/TLig7KNzg60gJuR/dTMJvl+6N5HkNE3nZpp8TM0v2rEwIZBR7nPjvpPoeuVuolUqYs1nniD8FbICaLEWD6B/dkWbDlMRIUT9F09D4eCx+/L2zSw6hjg1YnBk9AzUkUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759284356; c=relaxed/simple;
	bh=Y6HaAtFJtLGOJV4yfr/jVQuVJHQUmCOcC36xFKcXxFU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D7ooaqDHQ/4zs6xDbByS0jAZnaVFaMYN5957DXnEDTT0k9noc1ZDVkjzqSkJjMY+J6oLh4yNk7mJ3bIY2aOd/9oHktRwGUyajJO7aypUW3beNbxDR4yje2S6fvK0THa7z5+/RE5SJFAjGBBCQQPxch0AyNRzsY2PRZZ3Vdzla08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BR6T08QP; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-27eeafd4882so110495ad.0
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 19:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759284353; x=1759889153; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FVeC2yR6/fyOcGwJdvETBf827K0Hnz0K4NiV4bbwCLg=;
        b=BR6T08QPSkSwqQK5LVF9lSMh15YGNQjzrIH1LWk8MJtox5UprzzdSq1tNx0ERAMap3
         oo0VNGtauzV7pyBOuGTRa7yVD5RIjvpJVm5rpNv8E2qLiKFeMXS7CdU1pKaB8Vy3r4fI
         F1QMznVXEJVHZ8TvwAbhJ0IpN2e8yR3tAZ1lC1e3UtXlrugA0/nYWFqSIb9af0AqQ9YG
         +mrjP96EglgEc4P8BRnLDvAeO7VlISl12CYZFu9CR3iK78MClTCsVQw6CjFEDPeWywP2
         udOubu5Ku84oT2FU0dMNrtJd/b2BcQdq66GG8W+J/3bynCJ7KqwKxeOKUFEJXgoK+Z/U
         9T6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759284353; x=1759889153;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FVeC2yR6/fyOcGwJdvETBf827K0Hnz0K4NiV4bbwCLg=;
        b=fCeZiw488SNWgxQIiohb3Wdy2bSzOeCfHnyee2AU3Qu+7SG5dy3/OHiBKLbkoyCB5d
         Az9wTLSu2CCJvCFzw6Hfj/1ZmNgBWaGLBpRO7EtJ+2ovaQRbNcZ9ZtLM8/TJyOswCyGf
         OVnt2GERX45mvBzxvi65CFkhKRL6JRMFYiW5Zn6onbiM3KTEHtkJclu2l5+Ix8rC4RDM
         wMM+iMlR/y5YTUNCOtj6QwlcB8Bc5IhYM2/cU68onmpBnZwqSQZ0NsvanOIUOmw7k8hW
         MeEbzoTlDVgYsIchk9/jrSCOpyEBC9CmMkeCl1bQRp03opUXhi4gFNT1otxZzXLXLvH0
         /nhA==
X-Forwarded-Encrypted: i=1; AJvYcCUT5iqSF3q0XsBs5XK1xaLHxAXaPf4GCGD2lZgY4PRAZX/dT8l0/sheikBSebvnqQvW+5U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzA3pTV+gddi7H+raG/6jSeOFSqP3tobwArWUcGE2P6/QQwoAWt
	R0iFd9l1cAI+E4XvrT4ipYiFlcE/1261ptEHe/7X5GCyCezbUmdohc3CrKBZ5UQVt9Of7pxTaxi
	q5UWi4UoMocybCv+j1m/zaADTV3NQM4F73OEBJqOD
X-Gm-Gg: ASbGncvCTXzQf+TfapWi0q27tEZu/gRjfuc+ms90I1PzA2IhMP1BiTTcc7nBmP+mnJh
	q/lDJoWwBvZA33hOVg3iF6a4eEv3/kTu83jUAuAuI6yPDW6U9M8zUw+TgY0isal/WGnKHJcSQ0S
	+cTx+19iQgubOLiqrkBKAwtOaVDLPBF799emkh2Frz6dqleuCjBJT1QgxXsJ0290lyr2fyiFmjd
	aLEASpt+e/jnPWo5DCMHzT+fYCrYsoYfHCGbyl2ncYBbUxNeOI84iAp4uO0PkFZXwY2V9peeBUM
	/g==
X-Google-Smtp-Source: AGHT+IHNcj1SejlF9v6ljVGsWNKD2HUwrJwrNFztxLPCk0u6IVhVAr4lvWL+0HiJx8NWvVjDAG1A0mX0Hdeet/twNsY=
X-Received: by 2002:a17:902:ce0e:b0:24b:1741:1a4c with SMTP id
 d9443c01a7336-28e7fcf1f70mr2567495ad.0.1759284352345; Tue, 30 Sep 2025
 19:05:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901160930.1785244-1-pbonzini@redhat.com> <20250901160930.1785244-5-pbonzini@redhat.com>
 <CAGtprH__G96uUmiDkK0iYM2miXb31vYje9aN+J=stJQqLUUXEg@mail.gmail.com> <74a390a1-42a7-4e6b-a76a-f88f49323c93@intel.com>
In-Reply-To: <74a390a1-42a7-4e6b-a76a-f88f49323c93@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 30 Sep 2025 19:05:38 -0700
X-Gm-Features: AS18NWD0egat_nfpK-bvQfE8ox60B24A14Eh4qeClxcfsjJofgJuyxn0sTJC9_w
Message-ID: <CAGtprH-mb0Cw+OzBj-gSWenA9kSJyu-xgXhsTjjzyY6Qi4E=aw@mail.gmail.com>
Subject: Re: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
To: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	bp@alien8.de, tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com, 
	hpa@zytor.com, thomas.lendacky@amd.com, x86@kernel.org, kas@kernel.org, 
	rick.p.edgecombe@intel.com, dwmw@amazon.co.uk, kai.huang@intel.com, 
	seanjc@google.com, reinette.chatre@intel.com, isaku.yamahata@intel.com, 
	dan.j.williams@intel.com, ashish.kalra@amd.com, nik.borisov@suse.com, 
	chao.gao@intel.com, sagis@google.com, farrah.chen@intel.com, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 30, 2025 at 2:32=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 9/29/25 18:38, Vishal Annapurve wrote:
> >> On those platforms, the old kernel must reset TDX private memory befor=
e
> >> jumping to the new kernel, otherwise the new kernel may see unexpected
> >> machine check.  Currently the kernel doesn't track which page is a TDX
> >> private page.  For simplicity just fail kexec/kdump for those platform=
s.
> > Google has a usecase that needs host kdump support on SPR/EMR
> > platforms. Disabling kdump disables the host's ability to dump very
> > critical information on host crashes altogether. Is Intel working on
> > enabling kdump support for platforms with the erratum?
>
> Nope.
>
> Any workarounds are going to be slow and probably imperfect. That's not

Do we really need to deploy workarounds that are complex and slow to
get kdump working for the majority of the scenarios? Is there any
analysis done for the risk with imperfect and simpler workarounds vs
benefits of kdump functionality?

> a great match for kdump. I'm perfectly happy waiting for fixed hardware
> from what I've seen.

IIUC SPR/EMR - two CPU generations out there are impacted by this
erratum and just disabling kdump functionality IMO is not the best
solution here.

