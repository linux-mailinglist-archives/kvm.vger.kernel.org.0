Return-Path: <kvm+bounces-44722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DCBFAA06CB
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 11:16:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C9933B8EDA
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 09:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 743A92BD58B;
	Tue, 29 Apr 2025 09:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f5pWtWZJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD48B1F63F9
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 09:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745918155; cv=none; b=WwEeFbxIZnUEJavVryb7Q9HP4WsLLTsRgoL0nIIKOK17WfNLnqQMBugU58wwDVZLQ3by7cqaXjRd/J7ZgT7BjwF2LPPIPN1BCDjbO8IOY/qbFssZ3KSehif85nmA6krdTEoItarxCx8XJj98PmqFKNsElxY1Y5s/VIYLYzJzcaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745918155; c=relaxed/simple;
	bh=DmtOy/ZG9qrrV3/RcfFT98L7Kv6MyvS8sAjoX/+25k4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Q5RjVzrO9tCa799ve+puSS6MGKgvNJ4fGtUr1uLzSZCuOqM1kkITJvw0sytDrNVj9bXY+PC+4xA5c8g0JKZdWKY0mJ89rrvdiFLBISufL7eq/zhPzJjaoy9BXL9FTcd1hAL3Nfy6rq0o61Foh63uOsiA6VWmVyApW1d7K17fieY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f5pWtWZJ; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ace333d5f7bso935708666b.3
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 02:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745918152; x=1746522952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DmtOy/ZG9qrrV3/RcfFT98L7Kv6MyvS8sAjoX/+25k4=;
        b=f5pWtWZJRu+kSsaAnub9PXtLhXyTG9OKkJ8QNdIep3tvzywkRq/xZwBJ32fK+kxY+k
         MlIxBhWGw0ErBnJ3PXKLs8l9wTjI5qzXJOcXdys8tka/A1LKF2k49B+to0x4fA8eDAcH
         paTeoCC8R6LgjBqBGdS7mK4hFLuTNv6WAr/t5EXMye8CwsmTPafPzYSXehvVaPloUqwK
         Lyuhv1yUPXAvouhNNe502zY6T95hSDoeUhvvZcU4kqLFgsP77gzPUQM2T/gfWW6ctl0u
         O9qUROnUo2JleRp21XOZUdg3uXjc6Qw0tFm3eBOGH+m1YH6PI1+hb+jIDnuNHN5INHbg
         w6xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745918152; x=1746522952;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DmtOy/ZG9qrrV3/RcfFT98L7Kv6MyvS8sAjoX/+25k4=;
        b=oWzFVYUcLDTjdpwXX5uaGQ/PNMI1bZHfG05IVqZIc1BknZUkGRuxoqxIVMC4dRzHJC
         PU5RbRVnV01GJ6KAPN0PmgvkVXdr1CbnqfzTGuTQDFybE68GM7zEEcUKhc6rLdkjkk7p
         4eDYFNUI+Ub7Ga2cbgHkuyreTTxgYKFN2q2aAe02T9Qxl8HHeCdcW0pF4MvhOXQu3Cxw
         2Q98M0PbONTjVWMNljNduqHwWHIxl+sLcSnZrvE5XapBLkqm+6ueBAGGA35JodsA2DZn
         lo9icXo9nBYhb1OKwQQmYTI2ocg7hv7ZshApGEnlUJqewJcaXG4IrLt//+3kSFM33UIT
         kQMA==
X-Forwarded-Encrypted: i=1; AJvYcCXKOZdqDm5GXCkZTgUyAD/EAr7ljroycWcW4eq8/fOIhrSzFU2ZIdTMhwkRuRznfeGQBTE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwjdFK5mTD0rUdtXTsWTKQjO/Yg1pNmwCLkvrKKMhkhId/eJfJ
	LRVip5Rk7AdRBOqfS2u7TuABzAtz03Nt67kmAayWABxgiM2i1fSsHESGdie8Meg=
X-Gm-Gg: ASbGncsV/l3gtLMUqcZ+FJnDbMxD5THJCI2l7Qya1uVvZ0A+LqbUuTno+PddfwnPMLh
	juQpPz80fFRyUPgxJx14Pe0xnq16iIh1DSU/CJXg6J0ZuT96stgcQZQNFegEZMtzZN+ev2Q1hji
	on3WvsOtGQ1P2+lOnu/H7Cegdb26unwkQ/qWkKLNSxq8SKJisd1rYSgzRMR0xBxZlNMogFPLyL6
	Wzqq08aurtL8qPrtvTVSiLe6waE2SqbsMQfhhanjikSTI27ieGcMkNMI0BxNX+e8QwIj6o6gqRE
	ttjx8E/+vpEjMX73Frm24UYa+57VFDSHHny8sMdrfJM=
X-Google-Smtp-Source: AGHT+IFejMuzZX3IfeC1lGuUK4hm4+ZuXZbt8ZBZC4iacJFnjcoCd1UhcNczc/J3wiUMumQ+AK0wKg==
X-Received: by 2002:a17:907:7ba3:b0:ac7:ecea:8472 with SMTP id a640c23a62f3a-ace8493b5camr1153942066b.26.1745918152017;
        Tue, 29 Apr 2025 02:15:52 -0700 (PDT)
Received: from draig.lan ([185.126.160.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e41ad27sm745439866b.5.2025.04.29.02.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 02:15:51 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 994485F863;
	Tue, 29 Apr 2025 10:15:50 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org,  Peter Maydell <peter.maydell@linaro.org>,
  kvm@vger.kernel.org,  Paolo Bonzini <pbonzini@redhat.com>,  Philippe
 =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  qemu-arm@nongnu.org,
  anjo@rev.ng,
  richard.henderson@linaro.org
Subject: Re: [PATCH 01/13] target/arm: Replace target_ulong -> uint64_t for
 HWBreakpoint
In-Reply-To: <20250429050010.971128-2-pierrick.bouvier@linaro.org> (Pierrick
	Bouvier's message of "Mon, 28 Apr 2025 21:59:58 -0700")
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
	<20250429050010.971128-2-pierrick.bouvier@linaro.org>
User-Agent: mu4e 1.12.9; emacs 30.1
Date: Tue, 29 Apr 2025 10:15:50 +0100
Message-ID: <87selr49bt.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:

> From: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>
> CPUARMState::pc is of type uint64_t.
>
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

