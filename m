Return-Path: <kvm+bounces-3214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 273FD801AFD
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 07:21:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 933421F2114D
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 06:21:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF98BBE5B;
	Sat,  2 Dec 2023 06:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q8Pyakv2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EA71A6
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 22:21:35 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id 5614622812f47-3b844e3e817so1012252b6e.0
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 22:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701498095; x=1702102895; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5b8TkhNUEjXgRxqNFAYhkmQKz7n9iKCkNE5IDgOJ4cc=;
        b=q8Pyakv2A8f51sHdGOWW1mv2q4O9WwY9iId0A1kFTBjGHya646SlDJEpCvIEsXhlar
         mwdr0998PT51VcFk6Q9IUuH1XyTJ1Q/zwCkE3iXnOdO/wzJAOsRjKoHbEfrV/QYxAumB
         0Ay6xSBomGd2arbz74oYEnEo9YPoCpVjmJ+kQLAN6wBNXGejFsslsjWaf+VKc7jQIrqg
         +Qt5GDXcIlzgm5bsW3wkeQnGvNKtgiFVAa+QjktOXQPb6oZs09lH8g6jOH53RA3P2XB8
         YF+jToV3ZGg4+uuIBQ0+q8F9tFbbV974JjQ6KHg9LHQaxbeoAOYIZa5nLhs1qtaBxnuO
         7rjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701498095; x=1702102895;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5b8TkhNUEjXgRxqNFAYhkmQKz7n9iKCkNE5IDgOJ4cc=;
        b=Aemp5TkGkopNQMpRTzqWBFrWNvErFt6DQIiMGkc4nIhtUkTEWJqsnFCTm52UtkJ3iS
         nhhOsyLsrw4o3O+mi5/Ueakd464E3nQYbUTxcs1v50QQFGTXiOal3jK9Y3FhgFuTyTO3
         52FpqxDtb5KboQD7K3tyXLle1wOtzMqMTUIRX/E+8CkzxBm0CaTZwrKpAkzjgh3L30n2
         E3nBWex1SiQapBDUdbaP8d/aNSqmH8QIlucZRcmiTGynierwtKtvRMEDYQ1L0Wt9tUZG
         /EzdRnT60fHOIhySnwtV4p84kXXlXKE3VQklacTHoCO/Sv68aOhyWO1mfesa3a8dXdlx
         Cd3w==
X-Gm-Message-State: AOJu0YwPF+wpjYOAH4bZw7L7PATo7JrgrbyL0Dkq/RJWs3FTTtQEEzxB
	4TbGQ7bMy5wZoNmB+bFskdejbA==
X-Google-Smtp-Source: AGHT+IGi2zDm+Qs4vKqwLkq6U/5M+to0EYxOa/zUjPYtdouHSnFLkscTF6VyT7ulY15O6AjaGZUylw==
X-Received: by 2002:a05:6808:e85:b0:3b8:b063:9b6d with SMTP id k5-20020a0568080e8500b003b8b0639b6dmr1014391oil.95.1701498095001;
        Fri, 01 Dec 2023 22:21:35 -0800 (PST)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id i5-20020aa787c5000000b006cb7e61cfa7sm3947324pfo.36.2023.12.01.22.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 22:21:34 -0800 (PST)
Date: Sat, 2 Dec 2023 06:21:31 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Jacky Li <jackyli@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Liam Merwick <liam.merwick@oracle.com>,
	David Rientjes <rientjes@google.com>,
	David Kaplan <david.kaplan@amd.com>,
	Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
	Michael Roth <michael.roth@amd.com>
Subject: Re: [RFC PATCH 0/4] KVM: SEV: Limit cache flush operations in sev
 guest memory reclaim events
Message-ID: <ZWrM622xUb4pe7gS@google.com>
References: <20231110003734.1014084-1-jackyli@google.com>
 <ZWogUHqoIwiHGehZ@google.com>
 <CAL715WKVHJqpA=VsO3BZhs9bS9AXiy77+k-aMEh+FGOKZREp+g@mail.gmail.com>
 <f3299f0b-e5c8-9a60-a6e5-87bb5076d56f@amd.com>
 <CAL715WK7zF3=HJf9qkA-pbs1VMMxSw_=2Z-e6e_621HnK-nC8g@mail.gmail.com>
 <ZWpaoLpWNk_P_zum@google.com>
 <CAL715W+x5hv=qYogs0smVAjakeS=4dsuDpGrTE-ovze8QECtKg@mail.gmail.com>
 <ZWpec_P17GL01yL0@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZWpec_P17GL01yL0@google.com>

On Fri, Dec 01, 2023, Sean Christopherson wrote:
> On Fri, Dec 01, 2023, Mingwei Zhang wrote:
> > On Fri, Dec 1, 2023 at 2:13 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Fri, Dec 01, 2023, Mingwei Zhang wrote:
> > > > On Fri, Dec 1, 2023 at 1:30 PM Kalra, Ashish <ashish.kalra@amd.com> wrote:
> > > > > For SNP + gmem, where the HVA ranges covered by the MMU notifiers are
> > > > > not acting on encrypted pages, we are ignoring MMU invalidation
> > > > > notifiers for SNP guests as part of the SNP host patches being posted
> > > > > upstream and instead relying on gmem own invalidation stuff to clean
> > > > > them up on a per-folio basis.
> > > > >
> > > > > Thanks,
> > > > > Ashish
> > > >
> > > > oh, I have no question about that. This series only applies to
> > > > SEV/SEV-ES type of VMs.
> > > >
> > > > For SNP + guest_memfd, I don't see the implementation details, but I
> > > > doubt you can ignore mmu_notifiers if the request does cover some
> > > > encrypted memory in error cases or corner cases. Does the SNP enforce
> > > > the usage of guest_memfd? How do we prevent exceptional cases? I am
> > > > sure you guys already figured out the answers, so I don't plan to dig
> > > > deeper until SNP host pages are accepted.
> > >
> > > KVM will not allow SNP guests to map VMA-based memory as encrypted/private, full
> > > stop.  Any invalidations initiated by mmu_notifiers will therefore apply only to
> > > shared memory.
> > 
> > Remind me. If I (as a SEV-SNP guest) flip the C-bit in my own x86 page
> > table and write to some of the pages, am I generating encrypted dirty
> > cache lines?
> 
> No.  See Table 15-39. "RMP Memory Access Checks" in the APM (my attempts to copy
> it to plain test failed miserably).  
> 
> For accesses with effective C-bit == 0, the page must be Hypervisor-Owned.  For
> effective C-bit == 1, the page must be fully assigned to the guest.  Violation
> of those rules generates #VMEXIT.
> 
> A missing Validated attribute causes a #VC, but that case has lower priority than
> the about checks.

Thank you. RMP check seems to be mandatory on all memory accesses when
SNP is active. Hope that property remain an invarient regardless of any
future optimization.

Thanks.
-Mingwei

