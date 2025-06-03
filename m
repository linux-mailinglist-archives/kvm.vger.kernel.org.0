Return-Path: <kvm+bounces-48313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93464ACCA9A
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 17:52:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E28CD188E791
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 15:52:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A368023C8C9;
	Tue,  3 Jun 2025 15:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YtMto2KK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A4D23C4ED
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 15:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748965950; cv=none; b=TB0ty0z1k/UbMO6tJg18It5IPEnJFBKCLfJnjnScp7Dfi3+S0/rY1SiLkjcqcRC0DhOndPG0dKdADKoSHrecrXOKK6ENb363khulZQjIXChJjSfrHZpLFhJZPIJMG/isHegSRB5tfVVGn1RbbOxNxyRuW5mM+rzJLW0KwuzOE1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748965950; c=relaxed/simple;
	bh=Kom1FvGmNN4AktA0qlIy6SWJ+T76aJ6PeGi47O9AJIo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RozehEQKpNC6/s5vHrpvJsuwwflX7FCqyEDNuvs8kmoCHwGlstgxMxZ3kl1XcWJxehC/TtXwYahLLxm/KURymX8MdAv83F4+beUOfPXMJi7PvloM7mcHeNdMVKBEGdLfobVNSLZCIMclEGiymACVR6bGYGvo5sWwIq4VcoxA/yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YtMto2KK; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-55220699ba8so7309774e87.2
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 08:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748965947; x=1749570747; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qjddE60/sFBsVsbZFg6jRg0BTFNTg+M4Jsc4dNIh+7k=;
        b=YtMto2KK1UabFvk/lxsBUAkL9ETC3STrbniKqF/k2y8LoQ/KIbRMCIfhQm10BQSXCi
         HsC5M0gkQsA48fW11pQ0ERP3mRq+UGTxFiesXX00+/CoaYOf4gAwMFEhrrklGPdSTmis
         tZpb0iswtIDMpmB6HikmapHmiVWDfpzOsFgSxCgOTOFTHFVYI4LCSLVrG4mYAMCMS77N
         OifL0XQloYM3FkCcfo67iYb+8LRWZrMrwjc6O4CWGUJ+mFSP75b6pyXiOGmU2/xbfI/s
         sPenrZRQmpj6tz9AE5weqFv3XL1hWBtQt5pXZFOyzzy7ytcQWy2uMjjgPb8YrjgboGIi
         1lHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748965947; x=1749570747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qjddE60/sFBsVsbZFg6jRg0BTFNTg+M4Jsc4dNIh+7k=;
        b=h5ulc6xGGldGpb384+cZrPsCWgNH1M1AIdmxUGR8HZ518/+x94nlp4V73M4WPjQPJ4
         FLJ4l6MPxFt674OyTzA6UoKHK2uMvHqb6/709MsUuGDSpmkrjxQ7oAvAjKp9Chq8vFJ3
         NCbJNyPdNyenGXqoHpETNw3d846yY3EFJ16AuNKg98FoTE/S/rxzTADNTbcADqRYfJaU
         15LD+9NlhPFkvJeBw32dZm+pycXjFmVvmqzFjdmPdm5RjpjaQ7YuHtzH6UDyhAqOEdjJ
         CKHdHOcptmPfPdtcPj2z+Vo66cVGpriLTUyzXnnbYyveOQF503llKoU0YXGCUaDkjrrB
         7IdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIJCK+Hi9myw/M1qJytOdx5JlgOYNKesao7scapZIMqt1PmuETvF11PzZABpIooLlg3kk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgMi5qXCnTNhGCzEXpyhHT57x8OqQ4hYB7MA6VJRzWTz8g25vJ
	jGCgZ2WNxpfNTcVPnALsOfkKldp5CMzP9ttwg547JW54LsGP39b8P/e8GKVUuWNE/o3EPmjTsSj
	xqzNgx+c94bnorRKIG6UOR6VE7Fk+z503R8X/IakW
X-Gm-Gg: ASbGnct5D59qmVohEpV9YHcftq6hryw6ezgTe7TVOyj8uBerEgOoBMgocKKBS70aM0g
	JhvctdGKmR98TAJHfJ5Q/NQdHx6y2px7UZOv9LA5GNkRX1iVKrJPJl3kzTfd3sjzHFf17zrF/jx
	gsGixTCPIDmkPJAIm8g43WwLD6KRFqGQK4Jl0v1MPpEWA=
X-Google-Smtp-Source: AGHT+IHjmXSXeBbT3tti41aRnZ50eoa0HiGKXsFoshdk8Q/pgbmUMg0Q67xTVKiYvArL90DSVdFx1KE3KdfUPcNauv8=
X-Received: by 2002:a05:6512:ac4:b0:553:24bf:2282 with SMTP id
 2adb3069b0e04-5533d15e465mr4562646e87.20.1748965946794; Tue, 03 Jun 2025
 08:52:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250523233018.1702151-1-dmatlack@google.com> <20250523233018.1702151-31-dmatlack@google.com>
 <20250602170759.6031b4f4.alex.williamson@redhat.com>
In-Reply-To: <20250602170759.6031b4f4.alex.williamson@redhat.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 3 Jun 2025 08:51:59 -0700
X-Gm-Features: AX0GCFvsD4JhwVbtS5TY5lazg55wufky03yKoxmQPJ7mn4k7lhQmCqwoKQGWBcQ
Message-ID: <CALzav=fOVaD=5ihrbvHoTRtMHxgFaUUxxGDo8y_gzA9jyLSM+A@mail.gmail.com>
Subject: Re: [RFC PATCH 30/33] vfio: selftests: Add a script to help with
 running VFIO selftests
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Vinod Koul <vkoul@kernel.org>, 
	Fenghua Yu <fenghua.yu@intel.com>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, Jiri Olsa <jolsa@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Takashi Iwai <tiwai@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, WangYuli <wangyuli@uniontech.com>, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Eric Auger <eric.auger@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 2, 2025 at 4:08=E2=80=AFPM Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Fri, 23 May 2025 23:30:15 +0000
> > +function add_id() {
> > +     if echo $(echo ${1} | tr : ' ') > ${2}/new_id 2> /dev/null; then
> > +             echo "Added ${1} to ${2}"
> > +             return 0
> > +     fi
> > +
> > +     return 1
> > +}
>
> I'd suggest using the newer driver_override mechanism rather than
> new_id/remove_id.

Thanks for the tip, I'll include that in the next version.

> I appreciate the work here, I think this could be really useful.  As
> Jason notes a few times, I'd also like to see this automatically
> iterate through all the combinations of options.

Will do.

> Maybe we could also
> think about whether we can define some build environment options to
> specify devices to use and this could all be run automatically from
> 'make kselftest'.

That's an interesting idea. Maybe an environment variable that tests
will look for and use if they aren't provided with an explicit BDF
string on the command line?

    export VFIO_SELFTESTS_DEFAULT_BDF=3DXXXX:YY:ZZ.AA

Thanks for taking a look!

