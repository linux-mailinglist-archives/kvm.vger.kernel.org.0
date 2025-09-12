Return-Path: <kvm+bounces-57435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84755B5579D
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 22:28:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 462133B75F3
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 20:28:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87EBE2D24BF;
	Fri, 12 Sep 2025 20:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wx+/QIu+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1642C22097
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 20:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757708921; cv=none; b=pObQ/p6I9KyJ3ftM1upteIVy69TW0uoV6Y1R/wxDkmQWumRGLZ1zUyWqQfwHpu4Fi06Q6ZCkva4nJdJNCz6MTcgmevN5yzGhIyc6gVwLy5Tu4ZoSzCSpPfzkzkrzo7rPqKoJpZRZJ7oUT2tDk5vTERF42Yy1+NLfjA1YIGzwaP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757708921; c=relaxed/simple;
	bh=5CRQ1Wk/o0j/G2nHEl90c33QVDlowgMy5EcywRApncQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t+33BaxmZ6V9DIjTctk/VsL29JX77Dni5BjnTF578JtbElzgOjox71sVzpV/AXJAVfyxn+Bl/nBUlLaXB0O0C+DTzPXGDA1f1msyofPC2/zrOHS8KzChWSE8ILgJeu2/Q5q/ACRQn4JlA5JkFERIDeha576yFJfR1OB6xVPIOa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wx+/QIu+; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-621c6ae39b5so3846a12.0
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 13:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757708918; x=1758313718; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EkdPl3mJf0N7aHo7vS0NETAJN5x+QRdYgue6V4hYEyk=;
        b=Wx+/QIu+CfvykWXlvHaQoQtm09bFs+WO0BguULsjBr2JXkHX33ONwrs2p5vmGGrpIr
         lRgGSyyGoneGLYsih6Odzv4B/NBkKGUvdM5/EPPQlN0pWBOapKW5Nzx6sVIjx5CUOOdx
         CzrO33HNbCid7JX/hmVb/O3JHzFXtehT3IfM6AjQLLtnS8HpWL4s77Z8WE1aSqS8kB0M
         zY02ZG/wrAt1bjrWXeejxRtc45y1ZNVN9MXmdbML3PH/xAKTdWPbIl4/4GoIMmdKZbiJ
         aTR9ZLZlQ1OoUWgXBBkWJ5GpkMalJe6QjEX6uEz6qd0XcRGBJtNYTYaidDZeOp7XXW7b
         eJ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757708918; x=1758313718;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EkdPl3mJf0N7aHo7vS0NETAJN5x+QRdYgue6V4hYEyk=;
        b=BBHAZZ1IGDg3Na+9nxbfYWStc/sPB58Oeos/LPocKhjN2ss9MC7SJxqaJ9CFPvA4bM
         0fPnQ5BxOND3+3R80PBi5nzO2fxVkDz4WxPWeeYuxldjU3MjEkB2NDwMvAiEdqn4XlHu
         DM1aJqBEeQCHohmFq/A53RiiNvMbDl886Hn4sjyjY+CP9n6AynhFuBi2myh+JPVqKQKa
         qnYJcpo4rVHdcdIXFLAAb49/J2XLlopuRo98bK97jeSUrkQg51KjPr+GeIjNrLHI0vcO
         sofSYdyb6CWDDIsfRuBo0KIk+UOh7PVImPaGC5+BzQFF9DK5EILeJyu4v4XZqhWum5je
         cw/A==
X-Forwarded-Encrypted: i=1; AJvYcCXaLaeUdAf+MPVd5Ahh4fCdo6oEYNDD4XtBP7CNN8v5/Ck/Sh54QUoM4EmA5vxcXAGk6p0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVUNOQ6oJ0ThyPX2ep8bl8x+PgekH3kHT2nEgOPomVW1mSIKJX
	dXh/zTM8fbwZPLjc6176oGsMPttYMoNoZ+t4rMUYVkXLSPJ/ZLZfhobuQsl6m5gDG2QXEyHjo4c
	6ztFTtVDyHv5mLZedPdySPmQfXF0NatmmRwaYTRFP
X-Gm-Gg: ASbGncuWdTLo1nmCiQY+JDu1Xwl6iZwem9uRuxCzkC2oW1w43xphU+C4pTwivCJQZ4b
	/r9NHC3oJrpqI08MCQB4i9V+TZP10SlTnmArxUdoQEvYaa5RITU3nIJutxsiI+BFwSaRcKagYLC
	WijLfNVZZq8cO+ImbADFDB2g8/GxhDpqKnmJtcMZaRV2vTmsMy2wsN/wCQzBzTr4FgDJHee+D6Q
	0QFqxvNPqTaHZB+Gig8UZ1+
X-Google-Smtp-Source: AGHT+IEkvcIOSJdOnsWjngaZgia/B6ZJv/NV1qfDBSsgIsWPExuX3vienXVzLgwf4WmDv+gESSlL6lMpOoK3PXd9VFg=
X-Received: by 2002:a50:9991:0:b0:61c:b5f0:7ddb with SMTP id
 4fb4d7f45d1cf-62f03e263b7mr3303a12.6.1757708918218; Fri, 12 Sep 2025 13:28:38
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240815123349.729017-1-mlevitsk@redhat.com> <20240815123349.729017-2-mlevitsk@redhat.com>
 <Zr_JX1z8xWNAxHmz@google.com> <fa69866979cdb8ad445d0dffe98d6158288af339.camel@redhat.com>
 <0d41afa70bd97d399f71cf8be80854f13fe7286c.camel@redhat.com>
 <ZsYQE3GsvcvoeJ0B@google.com> <8a88f4e6208803c52eba946313804f682dadc5ee.camel@redhat.com>
 <ZsiVy5Z3q-7NmNab@google.com>
In-Reply-To: <ZsiVy5Z3q-7NmNab@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 12 Sep 2025 13:28:26 -0700
X-Gm-Features: AS18NWAcs9kOE63nWWnvE8--wogUnl2l6qpewdFnnoJGLyvlOpE75iYZG3HMwn0
Message-ID: <CALMp9eR91k0t9kSzpvM=-=yePGYmLHggjfvvhmD-qaxBCnRn+Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] KVM: x86: relax canonical check for some x86
 architectural msrs
To: Sean Christopherson <seanjc@google.com>
Cc: mlevitsk@redhat.com, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, 
	x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 23, 2024 at 6:59=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> Heh, and for MPX, the SDM kinda sorta confirms that LA57 is ignored, thou=
gh I
> doubt the author of this section intended their words to be taken this wa=
y :-)
>
>   WRMSR to BNDCFGS will #GP if any of the reserved bits of BNDCFGS is not=
 zero or
>   if the base address of the bound directory is not canonical. XRSTOR of =
BNDCFGU
>   ignores the reserved bits and does not fault if any is non-zero; simila=
rly, it
>   ignores the upper bits of the base address of the bound directory and s=
ign-extends
>   the highest implemented bit of the linear address to guarantee the cano=
nicality
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^
>   of this address.

I don't believe there was ever a CPU that supported both MPX and LA57. :)

Late to the party, as usual, but my interest was piqued by the failure
of KVM_SET_NESTED_STATE prior to v6.13 if L1 had CR4.LA57 set, L2 did
not, and the VMCS12.HOST_GSBASE had a kernel address > 48 bits wide.
The canonicalization checks for the *host* state in the VMCS were done
using the guest's CR4.LA57.

Shouldn't this series have been cc'd to stable?

