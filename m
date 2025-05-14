Return-Path: <kvm+bounces-46536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6AB6AB74B1
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 20:47:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BADF18C43D9
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 18:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4091328981D;
	Wed, 14 May 2025 18:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LPSS/wLw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0833288CA2
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 18:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747248442; cv=none; b=dxkJIg/aKa3On/F2EQM4C3ghEiedaW2FFn9Hkp+6msRf7xWGb3WJy5/NDbA+4/pPDrc3zfi8rbvk14vsVOlLZUqzaVZbMarAh+Pq9ww3p1yTHVeDwx8wrH12r62joSuAahZAoOzvUQzfjFnr4n2stYcGs2KlE/WrA2FL+N5zSnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747248442; c=relaxed/simple;
	bh=3awbIMSQiN3/pGR0RpgPT4JWQR1hMlp0LppK89PvjRk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rJcCYExmUS+d2M6MvA0eqi+ri9ScI53zXcDw1Wevl+EbdCIQVDJbfd3PjzpjUUoh3enjGprRu9GZS/01Zz+IUQvmYKkAv1t9L7dhpg6LQBjZmu1gK8iZMt7mrbkUodtuVCtgh0QZ2or4vJRT5Z0IBsGTvJ0WJb1r5KoTOwBkz4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LPSS/wLw; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22e4d235811so1815595ad.2
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 11:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747248437; x=1747853237; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3awbIMSQiN3/pGR0RpgPT4JWQR1hMlp0LppK89PvjRk=;
        b=LPSS/wLwd4CUdXM4EN6sIL27nwi4vv9JTO5XIR7mSSzIbA9bWJsn71dyWhfoqNzFG2
         GmcIp8aS5O3PP7r3G8B2CkxvX64md5ek+O7OqNydxdhgj5VeEUhmVtFmEIjwfTLqnmQh
         NxjZVRvRLaJErOoUJIqoLGj9xZF06mrOky4XQNkuBkUL7UXMcWMt+WB1FCTd3KBPutxX
         Yf1zf10YARddzUUL1Em2InSozmnK/fBGJyJUdSAJKxCrL159lGY4/+NiqkP7xlcsZVt2
         6yOZbxfG9BrsMdvUmrUotd0Q1qJevsUpQE2TSWTGxUWfywtBerFj+QSFcp2NZoxr/9W1
         8eKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747248437; x=1747853237;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3awbIMSQiN3/pGR0RpgPT4JWQR1hMlp0LppK89PvjRk=;
        b=AB776TT999UstwXfKucES3vEBA/6i5BAwTpzvYcPlGe6PwWg7RVHpuuZbrmQG82szT
         sMDR4dGZ3VUSqW/zLF1eiRGFOkWLSl5ijRT9vmi0jsu+uUI4FAz2c0JEdOYbyGicqeoL
         J8Z5FE1zxZ9Jjjcy0VHlD9GWvWtbISz/kBR/bpKeX88shEmnAV3U8S5h+Gqi2srHydOP
         o3Zhs+PVGyVCvSsfuGU5n5DKjQI2btq4CzN6dkGTHzwTXeK//t7ynqlmCC4m0+yeEXdF
         ELUa10gjmMnvw0SbTSvplE/G0Emrbjs3DSLZKcRHa80zvxIDL+IoLVZapv9OmZ1C6k+x
         u2ng==
X-Gm-Message-State: AOJu0YwE+cQPy5SQVgD2ETrHLrzSD2MMxhmMmFG4ATyksbeYQvOOsa7g
	JQ0Jf4YXCTVP5rJzZgqa9xhui7GVHsVZex/uPnUN8LKmb2bO6YB9acqjALo85cPgJygBx4hTrn0
	2XEoVEBeqgvxPEibG7rwc5Ois4NNKNdZeR6xT68yKY9fnSz4OHdXU
X-Gm-Gg: ASbGnctFqe1hnSZHur2HbJK6BMrbSP6uA/OZ1rOV0wDxLobZq0cAemKjraSUhzO6+Uv
	E7+3l51Cj/L3v6EVLJ9bsRsIKbc6vSBNvUZy7B0BWpxkndueK6XZ3rxfreu4vnZdLwizD4Edndm
	bN0MzqBdfba3z4yCcTeAeZQdeRYzJNLK69nj353LBZ2cREktMXXfdJPFSq0t/LCR8=
X-Google-Smtp-Source: AGHT+IGhjfKdP65xyQg67/NXzbV7pW0f+Hu2UEi2yS3ExllYJPmOzVNNcmG9t5YCc8aX8bIxr7a3OZxEdOsRqobUKu4=
X-Received: by 2002:a17:902:d4cc:b0:22e:3c2:d477 with SMTP id
 d9443c01a7336-2319815c4f8mr61594305ad.25.1747248436993; Wed, 14 May 2025
 11:47:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250514184136.238446-1-dionnaglaze@google.com> <20250514184136.238446-4-dionnaglaze@google.com>
In-Reply-To: <20250514184136.238446-4-dionnaglaze@google.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Wed, 14 May 2025 11:47:03 -0700
X-Gm-Features: AX0GCFuSqhpxhjpKHFPl-kNkD1G7Ak4DdeEQl0wFSdtzCrO2XNlX70uWf2FExps
Message-ID: <CAAH4kHYiDpE9m4fhnUPkWrBq=pmDwVGx_--zSSjw1wE8irXESQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] The ccp driver can be overloaded even with guest
 request rate limits. The return value of -EBUSY means that there is no
 firmware error to report back to user space, so the guest VM would see this
 as exitinfo2 = 0. The false success can trick the guest to update its message
 sequence number when it shouldn't have.
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Thomas Lendacky <Thomas.Lendacky@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <jroedel@suse.de>, Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@alien8.de>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2025 at 11:42=E2=80=AFAM Dionna Glaze <dionnaglaze@google.c=
om> wrote:
>
> Instead, when ccp returns -EBUSY, that is reported to userspace as the
> throttling return value.
>

Ah, disregard this email. Globbed one too many patch files.


--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

