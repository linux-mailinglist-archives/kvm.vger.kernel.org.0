Return-Path: <kvm+bounces-34184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B01689F882E
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 23:58:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C01FE1897979
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 22:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 877C11EBFF8;
	Thu, 19 Dec 2024 22:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XvPSo4Wm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A03155743
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 22:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734649069; cv=none; b=oBZ7S8MUNW/P9pehXGEE8iTPiARIBpZ64kTJx4YaqzVtlVYNu7hGhOwPDLq1h0qNg7PqioXo1x8FKe8KFs+NAaXEVB+/6sIUsOsPE4ERqJ4CEyIuFPIbbOmIoonLiiAjA+DINy+YR+06EadfrjLmjap9GDYFtZUKFOc4CgfDYMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734649069; c=relaxed/simple;
	bh=ozbVLWa3kcgp2dlCkLcyvnrSpJfgs/2P+zJiarAcdgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MBIKU4sqjbj4Rwv5jYVxLA9ZIjN+pFZTGM2EObD4pg/iT994FBNefl+XsylK8ygy1Sx9A7RqE38DAc76cl306YMxAreevD8BhuuG8de2ZQkpjiYuJ7dGxbWgyuRvxewJsgoPulTZC9n3NoS5UfAmZFC73w4imE/owP+MeSnLKqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XvPSo4Wm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734649066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+AJVGXOkSSyrfxvfm3xKOcUEC2hmO2cQvw2RTYg/8t8=;
	b=XvPSo4WmrzLkzpd98uE3xOfKWpkJIaTmRnNRa21VgmlB0YK/WVYa+YIqehecpEYa7rjd3G
	lVOGnsqijFQ85MyaFun3sk31T9BaPwemF5f0qmLdDlQQ84lzLgPF7hBY+uGQqbwCwYkCu1
	uaBQN30upVV+94+bP0HMwsCbG3JOwLA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-2ZiE38yfMjGSyi3oRWNrFQ-1; Thu, 19 Dec 2024 17:57:44 -0500
X-MC-Unique: 2ZiE38yfMjGSyi3oRWNrFQ-1
X-Mimecast-MFC-AGG-ID: 2ZiE38yfMjGSyi3oRWNrFQ
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-436219070b4so7246525e9.1
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 14:57:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734649062; x=1735253862;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+AJVGXOkSSyrfxvfm3xKOcUEC2hmO2cQvw2RTYg/8t8=;
        b=RH78VSTcGMqgPnpYyGx8xy4sh5uKCC3fadYFPZN4Rln5y5/rq13lai0aKv3LQ5st4f
         R3k0J1KDJzhEhYkqoqdx84lDSOZI92VjXVgOH2QpGybYlGWpsQShFxGJBMLfJpXxP2RC
         HccUQaVBgnLYVV+aAetnHhzTn6cEKYhyTFQ943825j6JB45zJgrsbQ4cU6GWZtxerv0e
         1iLzSccFjY+ipuf8m8HbzsaqOJMk5Vkp22a4NtGCX9vH+Ah1wmS6CdJ8BdHGONT7hrvN
         K50LtvxUAwPZB28gbDH27bXgXYooIYoOIcsD1Mo7e41Bpu00PCHD/FC52/3bNTV3erGV
         q/9A==
X-Forwarded-Encrypted: i=1; AJvYcCXeEFlPdn5Joxk/lJvqJ72EEjzx/DxUJAw4f1nGtNnjYQwVDazJu1h/E+6xhZI6CVNXBbU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOriu3yATXBXN3bGx6gUy39HM27/NRRUvSyQPt794GvfEkA0hD
	eFLaokzkX62KaAfnKQV+0o+/SWPF3WmWP7IsfJ/hwr7exDCNdYHqUiUx0PTdPADv8jrkJT8it1+
	b1/a90ukU8v9a8+JbN+1O/CPCGVfoi14+WfB/7aQVYV6ERgocSAvrKnIU5A==
X-Gm-Gg: ASbGncvNxzHsHj1hxDQCk4TcfdATrBTKoQ+3cGP07bDlf7p70lMA+TamRtmLs6lNX72
	4UsIIWMy4qImyEUXrMVjl9O4KLCZTF4YxRY+0EJmYAGW8ayTfgIch2Tfz9h0CCGBAiXwwFHUrRp
	P5bnYYKOwkZlHHcaWTOrLd/kvIfbdMA/4OYwcbfYbE3UXY+yZVsdd2b/P8LKVfx7NjLRauvHNlG
	KFTQfbwGinPe12r/GB1atWBp6pBWjE/zbBu0ZwilYy9bWDGcc+urX6gRc3O
X-Received: by 2002:a05:6000:1867:b0:385:e105:d884 with SMTP id ffacd0b85a97d-38a223f5be7mr665359f8f.46.1734649062171;
        Thu, 19 Dec 2024 14:57:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHwWDcDZZXlIS1Q0zP24WLNStUkbQ0ZsBan4fU4aL0p6lT7R5e9yK3Vkx+LF0uRG/S+zo+cGw==
X-Received: by 2002:a05:6000:1867:b0:385:e105:d884 with SMTP id ffacd0b85a97d-38a223f5be7mr665343f8f.46.1734649061850;
        Thu, 19 Dec 2024 14:57:41 -0800 (PST)
Received: from [192.168.10.47] ([151.81.118.45])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38a1c847263sm2548439f8f.50.2024.12.19.14.57.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2024 14:57:41 -0800 (PST)
Message-ID: <6b0c90e6-6b38-4ff3-8778-1857cd66c206@redhat.com>
Date: Thu, 19 Dec 2024 23:57:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
To: Keith Busch <kbusch@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 michael.christie@oracle.com, Tejun Heo <tj@kernel.org>,
 Luca Boccassi <bluca@debian.org>, Jens Axboe <axboe@fb.com>
References: <20241108130737.126567-1-pbonzini@redhat.com>
 <Z2RYyagu3phDFIac@kbusch-mbp.dhcp.thefacebook.com>
 <fdb5aac8-a657-40ec-9e0b-5340bc144b7b@redhat.com>
 <Z2RhNcJbP67CRqaM@kbusch-mbp.dhcp.thefacebook.com>
 <CABgObfYUztpGfBep4ewQXUVJ2vqG_BLrn7c19srBoiXbV+O3+w@mail.gmail.com>
 <Z2Scxe34IR5jRfdd@kbusch-mbp.dhcp.thefacebook.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 xsEhBFRCcBIBDqDGsz4K0zZun3jh+U6Z9wNGLKQ0kSFyjN38gMqU1SfP+TUNQepFHb/Gc0E2
 CxXPkIBTvYY+ZPkoTh5xF9oS1jqI8iRLzouzF8yXs3QjQIZ2SfuCxSVwlV65jotcjD2FTN04
 hVopm9llFijNZpVIOGUTqzM4U55sdsCcZUluWM6x4HSOdw5F5Utxfp1wOjD/v92Lrax0hjiX
 DResHSt48q+8FrZzY+AUbkUS+Jm34qjswdrgsC5uxeVcLkBgWLmov2kMaMROT0YmFY6A3m1S
 P/kXmHDXxhe23gKb3dgwxUTpENDBGcfEzrzilWueOeUWiOcWuFOed/C3SyijBx3Av/lbCsHU
 Vx6pMycNTdzU1BuAroB+Y3mNEuW56Yd44jlInzG2UOwt9XjjdKkJZ1g0P9dwptwLEgTEd3Fo
 UdhAQyRXGYO8oROiuh+RZ1lXp6AQ4ZjoyH8WLfTLf5g1EKCTc4C1sy1vQSdzIRu3rBIjAvnC
 tGZADei1IExLqB3uzXKzZ1BZ+Z8hnt2og9hb7H0y8diYfEk2w3R7wEr+Ehk5NQsT2MPI2QBd
 wEv1/Aj1DgUHZAHzG1QN9S8wNWQ6K9DqHZTBnI1hUlkp22zCSHK/6FwUCuYp1zcAEQEAAc0j
 UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT7CwU0EEwECACMFAlRCcBICGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRB+FRAMzTZpsbceDp9IIN6BIA0Ol7MoB15E
 11kRz/ewzryFY54tQlMnd4xxfH8MTQ/mm9I482YoSwPMdcWFAKnUX6Yo30tbLiNB8hzaHeRj
 jx12K+ptqYbg+cevgOtbLAlL9kNgLLcsGqC2829jBCUTVeMSZDrzS97ole/YEez2qFpPnTV0
 VrRWClWVfYh+JfzpXmgyhbkuwUxNFk421s4Ajp3d8nPPFUGgBG5HOxzkAm7xb1cjAuJ+oi/K
 CHfkuN+fLZl/u3E/fw7vvOESApLU5o0icVXeakfSz0LsygEnekDbxPnE5af/9FEkXJD5EoYG
 SEahaEtgNrR4qsyxyAGYgZlS70vkSSYJ+iT2rrwEiDlo31MzRo6Ba2FfHBSJ7lcYdPT7bbk9
 AO3hlNMhNdUhoQv7M5HsnqZ6unvSHOKmReNaS9egAGdRN0/GPDWr9wroyJ65ZNQsHl9nXBqE
 AukZNr5oJO5vxrYiAuuTSd6UI/xFkjtkzltG3mw5ao2bBpk/V/YuePrJsnPFHG7NhizrxttB
 nTuOSCMo45pfHQ+XYd5K1+Cv/NzZFNWscm5htJ0HznY+oOsZvHTyGz3v91pn51dkRYN0otqr
 bQ4tlFFuVjArBZcapSIe6NV8C4cEiSTOwE0EVEJx7gEIAMeHcVzuv2bp9HlWDp6+RkZe+vtl
 KwAHplb/WH59j2wyG8V6i33+6MlSSJMOFnYUCCL77bucx9uImI5nX24PIlqT+zasVEEVGSRF
 m8dgkcJDB7Tps0IkNrUi4yof3B3shR+vMY3i3Ip0e41zKx0CvlAhMOo6otaHmcxr35sWq1Jk
 tLkbn3wG+fPQCVudJJECvVQ//UAthSSEklA50QtD2sBkmQ14ZryEyTHQ+E42K3j2IUmOLriF
 dNr9NvE1QGmGyIcbw2NIVEBOK/GWxkS5+dmxM2iD4Jdaf2nSn3jlHjEXoPwpMs0KZsgdU0pP
 JQzMUMwmB1wM8JxovFlPYrhNT9MAEQEAAcLBMwQYAQIACQUCVEJx7gIbDAAKCRB+FRAMzTZp
 sadRDqCctLmYICZu4GSnie4lKXl+HqlLanpVMOoFNnWs9oRP47MbE2wv8OaYh5pNR9VVgyhD
 OG0AU7oidG36OeUlrFDTfnPYYSF/mPCxHttosyt8O5kabxnIPv2URuAxDByz+iVbL+RjKaGM
 GDph56ZTswlx75nZVtIukqzLAQ5fa8OALSGum0cFi4ptZUOhDNz1onz61klD6z3MODi0sBZN
 Aj6guB2L/+2ZwElZEeRBERRd/uommlYuToAXfNRdUwrwl9gRMiA0WSyTb190zneRRDfpSK5d
 usXnM/O+kr3Dm+Ui+UioPf6wgbn3T0o6I5BhVhs4h4hWmIW7iNhPjX1iybXfmb1gAFfjtHfL
 xRUr64svXpyfJMScIQtBAm0ihWPltXkyITA92ngCmPdHa6M1hMh4RDX+Jf1fiWubzp1voAg0
 JBrdmNZSQDz0iKmSrx8xkoXYfA3bgtFN8WJH2xgFL28XnqY4M6dLhJwV3z08tPSRqYFm4NMP
 dRsn0/7oymhneL8RthIvjDDQ5ktUjMe8LtHr70OZE/TT88qvEdhiIVUogHdo4qBrk41+gGQh
 b906Dudw5YhTJFU3nC6bbF2nrLlB4C/XSiH76ZvqzV0Z/cAMBo5NF/w=
In-Reply-To: <Z2Scxe34IR5jRfdd@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/19/24 23:23, Keith Busch wrote:
> On Thu, Dec 19, 2024 at 09:30:16PM +0100, Paolo Bonzini wrote:
>> On Thu, Dec 19, 2024 at 7:09 PM Keith Busch <kbusch@kernel.org> wrote:
>>>> Is crosvm trying to do anything but exec?  If not, it should probably use the
>>>> flag.
>>>
>>> Good point, and I'm not sure right now. I don't think I know any crosvm
>>> developer experts but I'm working on that to get a better explanation of
>>> what's happening,
>>
>> Ok, I found the code and it doesn't exec (e.g.
>> https://github.com/google/crosvm/blob/b339d3d7/src/crosvm/sys/linux/jail_warden.rs#L122),
>> so that's not an option.
> 
> Thanks, I was slowly getting there too. It's been a while since I had to
> work with the languange, so I'm a bit rusty (no pun intended) at
> navigating.
> 
>> Well, if I understand correctly from a
>> cursory look at the code, crosvm is creating a jailed child process
>> early, and then spawns further jails through it; so it's just this
>> first process that has to cheat.
>>
>> One possibility on the KVM side is to delay creating the vhost_task
>> until the first KVM_RUN. I don't like it but...
>>
>> I think we should nevertheless add something to the status file in
>> procfs, that makes it easy to detect kernel tasks (PF_KTHREAD |
>> PF_IO_WORKER | PF_USER_WORKER).
> 
> I currently think excluding kernel tasks from this check probably aligns
> with what it's trying to do, so anything to make that easier is a good
> step, IMO.
> 

It could be as simple as this on the kernel side: [adding Jens for
a first look]

=============== 8< ===========
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] fs: proc: mark user and I/O workers as "kernel threads"

A Rust library called "minijail" is looking at procfs to check if
the current task has multiple threads, and to prevent fork() if it
does.  This is because fork() is in general ill-advised in
multi-threaded programs, for example if another thread might have
taken locks.

However, this attempt falls afoul of kernel threads that are children
of the user process that they serve.  These are not a problem when
forking, but they are still present in procfs.  The library should
discard them, but there is currently no way for userspace to detect
PF_USER_WORKER or PF_IO_WORKER threads.

The closest is the "Kthread" key in /proc/PID/task/TID/status.  Extend
it instead of introducing another keyl tasks that are marked with
PF_USER_WORKER or PF_IO_WORKER are not kthreads, but they are close
enough for basically all intents and purposes.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 34a47fb0c57f..f702fb50c8ef 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -221,7 +221,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
  #endif
  	seq_putc(m, '\n');
  
-	seq_printf(m, "Kthread:\t%c\n", p->flags & PF_KTHREAD ? '1' : '0');
+	seq_printf(m, "Kthread:\t%c\n", p->flags & (PF_KTHREAD | PF_USER_WORKER | PF_IO_WORKER) ? '1' : '0');
  }
  
  void render_sigset_t(struct seq_file *m, const char *header,


Paolo


