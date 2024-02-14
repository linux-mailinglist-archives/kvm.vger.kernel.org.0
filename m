Return-Path: <kvm+bounces-8644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F8A385413C
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 02:28:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D20091C262D0
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 01:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F2910958;
	Wed, 14 Feb 2024 01:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aryhbU8F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDAC10A0F
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 01:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707873917; cv=none; b=JbwWEZb2VX/TW15xGY6rRp+Az0S79+/mFphRWpiSWQruWdrRpLyYN+9WBFifBz1JQqh0fPaTnTTQQ0yDgsJsqt6WzlirUlJoxETiCNF5l3+XjL64fSGhtYiTSCWCm7FkyscH93elVVTOvgt0zY+QeiaWlMOQ/iCCxJaewdD5zWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707873917; c=relaxed/simple;
	bh=kBmFiiY9jhtAVicGFCw6oDxKBEb/1sMPTS6zBLvauYw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VptCw0icvOV0CSlFVX/VxHCKJhzffE+ELa2NNj3GoBHavu04ypFMQ/Y5oEBG14H8pd1CE5/gEd/8yRiwS0A9QWQNC8+2TLlpklUMIzNBDfZ0jcL9AGKh1tkENkPVjzomwJomqeoOlNLd1SHEVEgLDv8UeuXKYMWso9K96p0H6pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aryhbU8F; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e0a461e125so3146924b3a.3
        for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 17:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707873915; x=1708478715; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3lhldJgYh3LnuFXh1KrZsXRF/R8L81Sit87YMrma8b0=;
        b=aryhbU8F+xkHsBm5xqeHgGhJ73EWPKyEjKFfBOLwn9oFA5Q6ICgoey3oyLrnrNn1Ba
         xKN8+CTgjSJygskcaBT4iloTlI9NR4aHOlzc7cST1gMlm0hkRtF3qJ15+OsCijXe3iqO
         WT1J9QLbBKwHLjDXMzpI6/W6iVZwlATST5dT+z2CRmem1wW+rFDzt7ofFkRx1IEw6dnn
         /fDa1jHEwnMczKXIvkR1P+Zkkxawmvk3TAZDK95I80NNTiSb+6KbqZuCSzLF0EZV+GvJ
         PnxoCVvXpmFgpEwFl+8yltfZYstT6gfzOGB+2Dqho0vtX6LXq1FsikO5It9aoimJtSVS
         wxHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707873915; x=1708478715;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3lhldJgYh3LnuFXh1KrZsXRF/R8L81Sit87YMrma8b0=;
        b=mf1JN1KUIo9NFnHthiHvxUu8w9ecO82V8JZ4BSSkhMckf7pAIKhOa0noB51W5mCD6x
         hArdi0UTukyC0BYUp4r6fqEH1zSmtHoMDle5tGOiUVlKCUcu28kZdlh0oQncaSAwc8Dm
         XovKlfqOI/W6d4KKjLJF0tGiA8BVqye1KxgXKhf30gB9rSZaq3gyp9r+ni82rXluqHSm
         E1TY1MSfFdyzEKul+7iofYPy6pZtINH8wSFXHBS1qJC9TjlLNN8+QPvR88fq6zFkRcJH
         zKlFW4jOBp/LaS8n9MRBqzKlVsExPe6dO/CNzeBuhMWwX6QoUWHwedcqOWc0468e0PHo
         mJ8A==
X-Forwarded-Encrypted: i=1; AJvYcCU24EGufzeVHjjKqvAYfupTMBde1nOykRZ7MYyOpTgsuShLehziF7HLCW5Ml+hg/w/sWjJKAlfbHWE1bNVTrHfGDjo/
X-Gm-Message-State: AOJu0Yy8u3D4WhUYFOz6pZvzkvSybhEluSqGkymrk/0HJp6sBTksgaSb
	CwmVyxmKFiNlg1brfUGN+qzjj9VHA5iWCoDD5xlN8UtBnIdum5w2imxGq8Xd9+j9xQFPVGz3kya
	Njw==
X-Google-Smtp-Source: AGHT+IFqV2lSphRIVe9wjsewmJ//Lgp0BElNWtsrnt2MAbcVpRrpiic5wlkUy+bWcOjElus+LklBUavnZlg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3d4e:b0:6e0:57f1:688d with SMTP id
 lp14-20020a056a003d4e00b006e057f1688dmr28365pfb.2.1707873915478; Tue, 13 Feb
 2024 17:25:15 -0800 (PST)
Date: Tue, 13 Feb 2024 17:25:14 -0800
In-Reply-To: <SA1PR11MB67347AE5FD9A8710F3921D13A84E2@SA1PR11MB6734.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240206182032.1596-1-xin3.li@intel.com> <Zcvxf-fjYhsn_l1F@google.com>
 <SA1PR11MB67347AE5FD9A8710F3921D13A84E2@SA1PR11MB6734.namprd11.prod.outlook.com>
Message-ID: <ZcwWeiNstRNHQiI6@google.com>
Subject: Re: [PATCH v5 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
From: Sean Christopherson <seanjc@google.com>
To: Xin3 Li <xin3.li@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, Weijiang Yang <weijiang.yang@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 14, 2024, Xin3 Li wrote:
> > VMX_EPT_PAGE_WALK_4_BIT)))
> > 			return false;
> > 		break;
> > 	default:
> > 		return false;
> > 	}
> >
> 
> I see your point here.  But "#define VMX_EPTP_MT_WB	0x6ull" seems to define
> its own memory type 0x6.  I think what we want is:
> 
> /* in a pat/mtrr header */
> #define MEM_TYPE_WB 0x6
> 
> /* vmx.h */
> #define VMX_EPTP_MT_WB	MEM_TYPE_WB
> 
> if it's not regarded as another layer of indirect.

Heh, yep, I already had this:

/* The EPTP memtype is encoded in bits 2:0, i.e. doesn't need to be shifted. */
#define VMX_EPTP_MT_MASK			0x7ull
#define VMX_EPTP_MT_WB				X86_MEMTYPE_WB
#define VMX_EPTP_MT_UC				X86_MEMTYPE_UC

