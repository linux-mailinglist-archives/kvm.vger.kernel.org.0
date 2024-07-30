Return-Path: <kvm+bounces-22703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCF5594213A
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 22:02:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 744A4286618
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 20:02:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9687C18DF69;
	Tue, 30 Jul 2024 20:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="HYfr7WYN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC601AA3E2
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 20:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722369741; cv=none; b=Qd/3QG4Am7gy0aPeHbDaF/ftaBSb2iYXhU9UvbO9/HTJe6MQy5V1yskJrQP/hzoZK0QS0IXAyXy/OhQeW87+0R6wNlSvHvh/JoNChVu+eSp+FlV/coC8vHsmIV2EMYGoTZIgHSMqrP8I7Uqe74G7JwSphBl6nMLeBg59AVDgcEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722369741; c=relaxed/simple;
	bh=g3+niUA0xpO8QTVJVcFoGPOfgBAUBJotciNokbhnVRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WWqLqLYuGdjgFiVw0olemt2uF7us4p44nS7WQPAVLcVPLHBKAoJ/DC/FGqE1cmV7lX2S0hxqs5MZ3wn9pJZ7eAK4QjOjzb9JzDHPeErGcCJgyJMN37eELMY9skbT+I/q5FfPzAMtAZaaLjlccoCFEd3UISJEaD9jfSNz8G9X6Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=HYfr7WYN; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-651da7c1531so37429987b3.0
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 13:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1722369739; x=1722974539; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2gM+dZs0nyyuKls7rKhwHwLihUP2+Vq1HQ7Y/s6r/BU=;
        b=HYfr7WYNGarWyLNF69C3lXcrXW/5WVaA+PPajlEQ0z7AieDIHFfyOwQO/a7k8Fkofh
         rso4vj3PmFroT1anQVjb4V7pm09jvAv0JMJwo5DcxD8nPYDe2gmu0eaTXLJqzTUDkaxj
         voWPaWN3QVYgGAM7jG3XAkcFtnvSxBocGSwZnC/9h1a8cdyt73QRareaVtEG9jXk5/y/
         IcUBny7mNWZb4oLjnriCRSBwJvEfU5PJN67SFqyTdLgKBELgdmXdtLLe8MfInSQIRUH+
         +7TVrEwPVVscO6OA0cd595IFLAY9ov5bc8Oqi/p+UlEAg5z1gYuJRbShFrkm9XQxKpLg
         YAsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722369739; x=1722974539;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2gM+dZs0nyyuKls7rKhwHwLihUP2+Vq1HQ7Y/s6r/BU=;
        b=cDGd4dQtRqMjMLAZSiRs8bwdSkxmPbCi8O+Do6daDrR4qEvJa+uO0KO8XzJ/J+vm07
         aQ0LxOfv3F1uYkpGrpnU5OZWGBw+MSm5FhKhZ3SxZHPQlp422/7vle2mwvjbUt7t1oTW
         ApjhiwFyzDH1/R3WC8nKtoigWCJSKKLI/j1SpT2CIwX0yP5Y9EHkQJP9CHhjnS6F8O9a
         uDJEZ1ayEbkoHBkIqAfKFKDBnZWVLlSU7AFoe+Zy6vCkCRGH39kA/Qfpc0c6Oz9UlWAc
         hnA8s44gojJ3GSto11OYii0Sbv6ZF5VUBC+N+4FdK1f1uAAsoZ49gtmRw7wyB6PfIhqv
         wePg==
X-Forwarded-Encrypted: i=1; AJvYcCWEnQzDsqJxGjaTr6NxzZ2imKb/dNQ6y3nJgP5tmAioBs4JePVK2Qxo9omPky2sLjGeLpkj58y0x7HzyB3+lq6SK6j/
X-Gm-Message-State: AOJu0YyihYTrpBSDqwKsX1/Mi7sEyn82updRHfZSuVVaX4NOW8CWvGap
	SR8bX40LNtiot0hmoMGnXtCVS6CCOIkHmMiY1Yv/wwUqr4hgdzWwwbqO1OmLQx4=
X-Google-Smtp-Source: AGHT+IHLhGc5P0Jkbn9GYe5+/TwFVFrZFTBX39bypM6SoAI4XaUY0Lf3nB+cU1gq/JuQtI04+biYKQ==
X-Received: by 2002:a25:d6c7:0:b0:e0b:28fa:75da with SMTP id 3f1490d57ef6-e0b54402a04mr11264617276.1.1722369739201;
        Tue, 30 Jul 2024 13:02:19 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e0b2a93fa51sm2532245276.54.2024.07.30.13.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 13:02:18 -0700 (PDT)
Date: Tue, 30 Jul 2024 16:02:18 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>, bpf@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>, kvm@vger.kernel.org,
	cgroups@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCHSET][RFC] struct fd and memory safety
Message-ID: <20240730200218.GC3830393@perftesting>
References: <20240730050927.GC5334@ZenIV>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240730050927.GC5334@ZenIV>

On Tue, Jul 30, 2024 at 06:09:27AM +0100, Al Viro wrote:
> 		Background
> 		==========
> 

<snip>

I reviewed the best I could, validated all the error paths, checked the
resulting code.  There's a few places where you've left // style comments that I
assume you'll clean up before you are done.  I had two questions, one about
formatting and one about a changelog.  I don't think either of those are going
to affect my review if you change them, so you can add

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

to the series.  Thanks,

Josef

