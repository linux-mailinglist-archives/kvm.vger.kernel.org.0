Return-Path: <kvm+bounces-42292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CBE6A77526
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 09:24:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4C027A332F
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 07:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A387D1E7C32;
	Tue,  1 Apr 2025 07:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nuEwIoFy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FA31E2606
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 07:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743492246; cv=none; b=nUg1QYOwi7AzdIXsm1gmFhK2UgNL1okGZyP1MJro7cvYymwcMTRFCSYkpR7Hb222q+4SjnjMPUs63fsVBTeKzxOBcmRroREv78k1W6KNRbiKXR3G/96AoPv/ooqMVptlDCyMIwEO3G4iU+BxJc9zZX2qvZk03zTkxqBHrflPrKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743492246; c=relaxed/simple;
	bh=wteELlvUiRIh8tg8HmF0Q/OW9f+kbkAeNZjA+BLMH2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NeysY89mlQCkkOaadXpZeC1Jy/yekQ5vcgA8otjc1CXtNgpd6zlSvJUgp7SsZV95Ile5PAXlQfwlHjEWVnkXl/Izzsi2HQSBKQ9dtAl0f0S887HvDa+OnJOJXiIc61yOOXUToWIvnYKMOuO1oXx2EMrrlnC1pM3TghI3PY0J/S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nuEwIoFy; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2242ac37caeso86965ad.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 00:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743492245; x=1744097045; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TsyIOn8ZLgt3JXXRxvHc1//6+0zk6fYjlwYFayAxlEM=;
        b=nuEwIoFyQvP3z74ZZXjZM+8TZ0FanuEjPnuu7xs3VdU2U8AIAabe3wxtpcX7ACwNg0
         zWuuvy2n/kwKnkv4u7Tk8wsHTi0QLaeVjS94uyc1X5oeYOXUNYzE1hItPaqqWOZ98DfC
         xrSoBmQw3rZX4igFYm5TrMaAXRYcFj6LfLuwX9QLkeqePUyXNv3dw7EXbUSNqgu98U/J
         DYOIJfBTBt+6F/ueqp3Ii644m04XdqQBIRwV3gKlPAhBwFMbEauHfkvT5pGsi4mwoVVz
         pav/ZKVsPTugMN+OXuD0QeTZUM8Ge37IqxJGYOLxXXDwIjZmJwL1X2pBz8CJuikOwfYX
         aNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743492245; x=1744097045;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TsyIOn8ZLgt3JXXRxvHc1//6+0zk6fYjlwYFayAxlEM=;
        b=T6dcu4pAiVBbotax1akyVf2n/CsNcuDLPWly37laltRHySbjco3BjzK3pCwVmYmTbe
         d9zSrQI8gjtzPWU26bg8mWispCxqgJyKj+wqqzxMxCv2R6Owx3t3A8V1ezpn5mrcYVqT
         C1oigEKC8aDjONIKnUwdvAi6BUAdFmkzo4WhhfficSoA5uBaDQrZG5BDKEH33Lc/d5f2
         GQrA3QbM7MY9qNNm6UkFhPLxK2Thwuyv/wiV4/NLG2vVd9GucrToAFmynTAjQH70uO8R
         PILTiN1x0EQ+LInl/Xr1ZfZIpP3GIN+S8KjdsFBgNZ6d7RYYjO2ycYabcKq8lMDwhn4v
         bN9Q==
X-Gm-Message-State: AOJu0YxC37kIO5XY8pQCalfqpWaM3YVMop1lON3b9ZhtjuKIjbBn+sTW
	38g92btDg+bd8TN2Ug4exh8lKDZFOblXYcsPQneDWM17sqjmNo0Yz/SN16Sft5hTmpjxdBs8Gko
	X1Q==
X-Gm-Gg: ASbGncs1PemmAS2wYFIQX1ElGkWz0PDkrkedFhuI/fHnZpvpB1IeSNCpU/klqfUVYdz
	SO7bnBgOCPVPvKgay8MaZ4m3r4WcoDyY4pzgzS3SJ32EFALEkOZ+LhlHYYwNlTq7+uuFkBeqOKF
	XrPr4WXW+0Q1azKs4TkAgQOJooXDEPI8K02+XNNSfG77wNMjXhiOWdqUvuvEpxczdglPgwi9y/N
	LFTN+nPWmDHczGTaZGICMFxxVvlfudJnwFJnVE0SCMpHjRUZinM8gHiiZDefgpY0NB2F8NdYOo8
	9CshATyIhcuzOJOccWGfT0EnaXr77zmPUGgNhr1n8cPY9cQZAOD7eTId9EVDNRQjo2rP7C7rfhb
	KRaY=
X-Google-Smtp-Source: AGHT+IGJUEKyE5W7uWNFNe9WdghG5jnj3vvDLqSpVFfWIy2PMup4kXI+QCDA+dqN041nSrqdQE1iNQ==
X-Received: by 2002:a17:902:c1d1:b0:216:21cb:2e14 with SMTP id d9443c01a7336-2295d0d88ccmr1285405ad.21.1743492244521;
        Tue, 01 Apr 2025 00:24:04 -0700 (PDT)
Received: from google.com (188.152.87.34.bc.googleusercontent.com. [34.87.152.188])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2291eedcedesm81725755ad.67.2025.04.01.00.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 00:24:03 -0700 (PDT)
Date: Tue, 1 Apr 2025 07:23:56 +0000
From: Pranjal Shrivastava <praan@google.com>
To: geyifei <geyifei@linux.alibaba.com>
Cc: kvm@vger.kernel.org
Subject: Re: subscribe kvm
Message-ID: <Z-uUjDiOi4hELSEP@google.com>
References: <5e2893f1-41cf-4d1e-9a04-26d984ff46dd@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e2893f1-41cf-4d1e-9a04-26d984ff46dd@linux.alibaba.com>

Hey geyifeim,
On Tue, Apr 01, 2025 at 03:19:49PM +0800, geyifei wrote:
> subscribe kvm
> 

I think you're supposed to send an email to:
kvm+subscribe@vger.kernel.org

for subscribing :)

Best,
Praan

