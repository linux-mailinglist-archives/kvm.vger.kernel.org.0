Return-Path: <kvm+bounces-55038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86DBDB2CD5A
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 21:53:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC2132A5E8E
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 19:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E86231E11F;
	Tue, 19 Aug 2025 19:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="toOUvPEw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351AB2D24B0
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 19:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755633188; cv=none; b=rMd7GI6G1ojJ4s2/CsrdSPET116pF1HvnHiQZ5nBamKGuzEAwI0eIUgdCUUvCltBd59GMyX/8YFJNlj/TwL/jAwhicw1hBnG3iv6ZR5nDYpc3AAN7bSScLmO9oTZGq15AMiMA9wdTAo5mW7o+t7HkwR2oz+/20E+77wdIXtOPUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755633188; c=relaxed/simple;
	bh=JnxEPf0TEltZpl270Q1R4nTGFbvYaUy+hFvUN4loxT0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YPXW9p021S7FCAZ31y6BEXNyCtja2nHq7o9onbB+BNetlnwtYTJwAqCG+tJdjwgHdeXRllfKbOgEWCmwyKnUXwmexZNGT9zLiCV7hy4BNZNgZzkwiISRroqz7RE04uIGRqfrsxoUDvBpw9xLptK1xCJfPGtF/ITJJ7Vx2Kc6eIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=toOUvPEw; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-242d3be5bdfso40225ad.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 12:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755633186; x=1756237986; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=er2Ukb2ahIabEGfku52pux0+8CgRuxqD53WzYKTy1kM=;
        b=toOUvPEwuDz3sSM9JDlD4s9uVdFP54EnWtks6eh/R4bximOd9zfoHArVrYqTCaLHt8
         m0idngH8DewEYmvW9vcRgXIl2P767ubttB3YVhoNkfEvjG2eNX7Das2criwEbySB5vII
         iiY3xi/GQk05tdQFkJvCNUphZ17VTNb95es0JbI5vWcdv3TZMGsseHi4pu9GkGVZT4sN
         04fK0O1xKD7LFpDkZFGkPK9unIB1K9ZQoPpGDwuhrFsgXsU5qjFDJ8up8+/IZhhwVCxl
         arfsWuI+FFMEDu8uPWkXBucm12r8uY9LPYIhmxtOwusr0GHDvEAjDM2sP5dhArc9mgIl
         OD6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755633186; x=1756237986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=er2Ukb2ahIabEGfku52pux0+8CgRuxqD53WzYKTy1kM=;
        b=d/Z+g1JkoV+tNaqJPMB2P6eWlRJWFnrgfYdvaLAGMB3KTamcjWq8+qzBnScyh/qXqI
         e/aqcxNFmDl0lLw4ta6yFUAfrq1fomPitE6uFj/qSQRKOnmJPXMNKhhrYhGCEbNN+ufj
         TMnWTYaD+Y1hLyEdr4TRq5bpKUulzcIgBkQmldW49hk6EuxSYSTHYwoR1GSUqWAhYoN/
         BlcUoPOvPYOFQVMm6E8InFW6MIwkklF8hi6K/0YcUKA+1Koe/7ZWxx1SoBLZ71Avt0Ef
         2B3zlN6C9OPCGNvRZBXOtFZeHLfKG3h/CCTAsneTVdDGtEMY9FW8f+0J+oqKU/JYEKuU
         OFBg==
X-Forwarded-Encrypted: i=1; AJvYcCWhBCCjtqveH7iWKewbCIfthox1NUqkb8UXcuBXHU+bGKsrf3XhdsMpQgJz+yRenFaGomE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwI31EYCA1pHb15ebRBxb6fXk1WPIc/EUjOFlqI4+LMWIVexwDt
	qYhkufjmC4sy1sEL1l9a44Cw5lcAXa0Yba6z6KqxTe4aReSfyqARCMX5cOYc6Y98iSlFAOVjUnq
	jCGLoLbY5eiu2+i6Id5KV4c9MQMXr1eeLcHk82KSw
X-Gm-Gg: ASbGncuYm4hLKRRIL1iV4cb8GeLNwCU+8JAfPXqcmZIksk0cnaNxPjSc8bGuUH/ebvL
	MJNfspbI8vAC4GvEXLNj5nCzwnAxelafV4yJhgyck/atonoXUm8JGjsHxkvzYSry52iuetR27i/
	DBU5sDdp4aXj3BIbDfmcXfwRibbjPXQ+kGRZZO1hdyfFT1nDhq7aFSxOEt9WslN9WtZ4DOzlFFI
	79CqIvwzHAjip09OAvYah2oO52p2lqJmh2ojOEiEBWHzIYOZCzagk0=
X-Google-Smtp-Source: AGHT+IFz9bL0u5jDF4CT/TIBN70iRgmzt7yhWGrdHZGgY7hHAFTzW2uCxBVn/7FRz1cEus2s5daf5jYu2U49bgUukpo=
X-Received: by 2002:a17:902:dac4:b0:240:5c75:4d29 with SMTP id
 d9443c01a7336-245ee6d85bamr947615ad.0.1755633186093; Tue, 19 Aug 2025
 12:53:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250819155811.136099-1-adrian.hunter@intel.com> <20250819155811.136099-3-adrian.hunter@intel.com>
In-Reply-To: <20250819155811.136099-3-adrian.hunter@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 19 Aug 2025 12:52:54 -0700
X-Gm-Features: Ac12FXzFs5xLT7p_v-1frrxaLFRvMe-6lrfP9b_-Raz9sQEjbrTaAkx3gEjOq_I
Message-ID: <CAGtprH-pv3ReYZSQiof_2Uu6RT4JNLSHyMuw7AuSpciXML5HoA@mail.gmail.com>
Subject: Re: [PATCH V7 2/3] x86/tdx: Tidy reset_pamt functions
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, pbonzini@redhat.com, seanjc@google.com, 
	Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org, H Peter Anvin <hpa@zytor.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kas@kernel.org, kai.huang@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@linux.intel.com, 
	binbin.wu@linux.intel.com, isaku.yamahata@intel.com, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025 at 8:58=E2=80=AFAM Adrian Hunter <adrian.hunter@intel.=
com> wrote:
>
> tdx_quirk_reset_paddr() was renamed to reflect that, in fact, the clearin=
g
> is necessary only for hardware with a certain quirk.  That is dealt with =
in
> a subsequent patch.
>
> Rename reset_pamt functions to contain "quirk" to reflect the new
> functionality, and remove the now misleading comment.
>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Acked-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Vishal Annapurve <vannapurve@google.com>

