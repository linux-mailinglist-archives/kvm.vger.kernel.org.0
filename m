Return-Path: <kvm+bounces-5736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8011A82592E
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 18:38:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2510B2854B9
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 17:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3087347B0;
	Fri,  5 Jan 2024 17:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZAGkAHS+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7EF34565
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 17:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-555936e7018so2118092a12.2
        for <kvm@vger.kernel.org>; Fri, 05 Jan 2024 09:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1704476320; x=1705081120; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EuEZczdUv3gZvL7IiLeH7OBOW4EIGVkBa564euOCBMM=;
        b=ZAGkAHS+Gj/WhACN9MKcrGl88H3AgkREc5CjZlgEWvFWEbja8QHSbDOddwlbL9Yh9P
         GKA+q/6gR+Dv5ClYvSMA0SqFNlBBU+C7sI1xhqc2ngp/GPd0We7jEzLh8dFWSTq1eeo+
         +xQx924k0a542hBJlgEuMdPYI4UvksAaJeWiw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704476320; x=1705081120;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EuEZczdUv3gZvL7IiLeH7OBOW4EIGVkBa564euOCBMM=;
        b=Hf4QG/crqY0Q5XlHeFp0EZ/8RoU8+Z662boS3i4tsD3/wzojycJnE+Y8mL7BJBl3bA
         j9gjKM6si3hsPq8g0YgaBU4q8u2Fn4V/bdFwTSLeTw9qiKBgbhfNoUBxsposI+OPuson
         ffRg3M5REv4lkSy8tdjAISdwcQ8slgloRkLa+RaCn8zrop18Q2iN/HOMC9WtScjB+eUT
         5BCwA5ajnO/pYP8OmYFdAll6v/L8AbQHHo4fE75WhBbzQ+62sUznIUlOIhzYF41brCYR
         aPxYQzyz4YGxrTIIvH0aZ5xJiPaN0IjxcJt4mMiiH02GhXS7fEgERsuT97V/oOvFUud7
         vOug==
X-Gm-Message-State: AOJu0YyFX8JmoijqIrBvvnculHC/cFHDsMDitLIKsMoU6XNnZiwTC+0C
	YXyNyb3hKLHfs8fn9QkU02r3nEhIIRanYfNGfbvKfZzwVueVn3w5
X-Google-Smtp-Source: AGHT+IG5RiTmkNEJ+bKVffeLVRsrqzDpgGh7Wigl6oD3M0bQ+tSnWvw0nnYUMy6UY5O9X8Rc1z6k5Q==
X-Received: by 2002:a50:ed11:0:b0:555:363c:d918 with SMTP id j17-20020a50ed11000000b00555363cd918mr1400491eds.25.1704476320377;
        Fri, 05 Jan 2024 09:38:40 -0800 (PST)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id fd5-20020a056402388500b0055743d6e9ebsm314867edb.41.2024.01.05.09.38.39
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jan 2024 09:38:39 -0800 (PST)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-555936e7018so2118067a12.2
        for <kvm@vger.kernel.org>; Fri, 05 Jan 2024 09:38:39 -0800 (PST)
X-Received: by 2002:a17:906:2257:b0:a27:a7f9:4a86 with SMTP id
 23-20020a170906225700b00a27a7f94a86mr1230919ejr.39.1704476319444; Fri, 05 Jan
 2024 09:38:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240104154844.129586-1-pbonzini@redhat.com> <CAHk-=wi-i=YdeKTXOLGwzL+DkP+JTQ=J-oH9fgi2AOSRwmnLXQ@mail.gmail.com>
 <ZZg8kbb3-riiLbrb@google.com>
In-Reply-To: <ZZg8kbb3-riiLbrb@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Jan 2024 09:38:22 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjc5x_Y=MX35vaoWodpfOU86_gm6BQTGWXgDeFMPneTrQ@mail.gmail.com>
Message-ID: <CAHk-=wjc5x_Y=MX35vaoWodpfOU86_gm6BQTGWXgDeFMPneTrQ@mail.gmail.com>
Subject: Re: [GIT PULL] Final KVM fix for Linux 6.7
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	peterz@infradead.org, paulmck@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Jan 2024 at 09:29, Sean Christopherson <seanjc@google.com> wrote:
>
> Ha!  That's what I suggested too, clearly Paolo is the weird one :-)

Well, it's technically one fewer operation to do it our way, but
Paolo's version is

 (a) textually one character shorter

 (b) something the compiler can (and likely will) munge anyway, since
boolean operation optimizations are common

 (c) with the 'andn' instruction, the "fewer operations" isn't
necessarily fewer instructions

Of course, we can't currently use 'andn' in kernel code due to it
being much too new and requires BMI1. Plus the memory op version is
the wrong way around (ie the "not" part of the op only works on
register inputs), but _evenbtually_ that might have been an argument.

            Linus

