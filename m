Return-Path: <kvm+bounces-47684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E88EAC3BEB
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 10:46:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D010C3A4DC9
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 08:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ABC61E3762;
	Mon, 26 May 2025 08:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b5ND79As"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6979418EAB
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 08:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748249167; cv=none; b=dEVBFQxjfQL8vUW3i9BmbLv+B3+Z6z1pSx1dLefaDMZB11LmPFJhAESVBpCHtla6V3u7RLSDW5s5npWR8pPBuT3zImucANpYW4jRI88K2ABK0FI7pFQU3+TcCkHZOIrTBe2h+O46AOArNgUw4/ej6diLdkCvuZvoYVtDoSjtkCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748249167; c=relaxed/simple;
	bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=j25URAkeoMT4fl1kaywrVYiK1RRyxNDfuj1jCpbhFmZjDA6qGuXDJv0sMCMvoxKTzyT4ySv6XkVMczU2Wfy+6tLyoMIvfzFxD7DtW0JZjibpbrPdPP2OBb+PTn2thweyXOuqq0kr7cJd0kH6x54ZfhXuHlknVSnw7gNk3T90J2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b5ND79As; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-232059c0b50so15188995ad.2
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 01:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748249165; x=1748853965; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
        b=b5ND79AsYPwEjCh+6dZbW5R8SUCSGAVIJoKsGbHNlXAOqi1iXRcD8JxMXT7nqZxfHO
         jGGU3faFVXqyguIgfDBHgR8NZ5+II+z9SMCGE58KBJqEExWk6Qe5aKhjFdoln566TU+/
         +AlYFryiWZv0JByqj5XlElSBVwtztLIo7nnxkhqn0o7qHoGjaY/F4GkAPhEnkXhQPt7r
         vHdhpY137MxAgH9RzWI9PZGm+8qZo+AurZ9kb8uR7WQlBbEiGifwg46bFSlqkmbXrdZM
         EajJ8DUHIL08n+Sjb32vkbRNq4DR8iii5/WNGY2Oo/EpjgvIEp3PWvusPeCkwHKJ5VLw
         mXDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748249165; x=1748853965;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
        b=iBWSKv/+8stmGOmtHH812Kw3k4K+8JoNC8KXD+UweH7t0QaflMHC5s8kejkzwFl3YG
         btiGeglE0OcmObphSwilvH0knv29A0HrURMCM7ckvx+2obnsZvvsqQbgCDg5pww//rpU
         uiP72Q7qlnW0ppprpBfVB/82uSOMJDjuoHJhZYabuOeF6gVZ9O0pgJa5owPCoxM6o5cu
         nM4vxYu6Zbu1E6UiExDmKDK/glOqb11ww9WyXAxpTbgoeL98+vVCvw0KFQv+Q+3MFEUr
         qbQVoWxlfsAd/5U74D051xdKFqnOwoaV9NtYJRlAxeypmkOGqkKFbaWKTnC8APzVCaAy
         cT5g==
X-Gm-Message-State: AOJu0YwtLgd3zxPTk4xxhgjIH5XR/WkndgUkqG1ZUpzAGns140qun4LS
	39yl/JfVW9W2d5wsUOfRyrI8u2x/FugrZZVM66UFV4V8LFhaonpKAT4HzWgY1ZDO6xnUxhyNG7f
	A4xLpYTBo78oWxrfbp4GLEegJ4n2iNOnBhA==
X-Gm-Gg: ASbGncvHzBpmtBY91YRphpxS+AOI2/gWf1p66R7c3IEn7HyRDJEFAj1knyNjnoML91S
	hmLORNSgXLEOZYCKV9WtcfpgQYz/6aj50HSkxjCtyDl8OIl2HNuvjVhsIf2zavEqU827KHIgTCC
	qkTBsLA05a4zrxgciJJ4N63uLdBNS34rAZJH/aQ8lBfyg70S6y0ebh3wftoHh85FSMgVQ=
X-Google-Smtp-Source: AGHT+IG0T2+1y3gNfXLSDJjlv1DggocRJDP/XlVNnzFiqR8eGZAac2tthTOP8ULQqnNOtNkp+I6zX2sWGWinru18KqQ=
X-Received: by 2002:a17:903:228c:b0:22d:b240:34c9 with SMTP id
 d9443c01a7336-23414fd54femr144868945ad.53.1748249165352; Mon, 26 May 2025
 01:46:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: opensource india <opensource206@gmail.com>
Date: Mon, 26 May 2025 14:15:53 +0530
X-Gm-Features: AX0GCFvKXnUGKsm31-hdnVtzGcREQ4iw6XAVVtbmVo6qR1VYUUMS3ALO7Owor_A
Message-ID: <CAKPKb89wkiu-eSaWGiYH-whDa_CHvxk4hJAWqZ=D3s7gkd4mgA@mail.gmail.com>
Subject: 
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

unsubscribe

