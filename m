Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF06D166B0C
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 00:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbgBTXkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 18:40:17 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37728 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgBTXkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 18:40:16 -0500
Received: by mail-pj1-f67.google.com with SMTP id m13so186610pjb.2
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 15:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=SP7bBr9H6yAJpQpgXdluiHzYEyyCb5Tm/zhjuI1xuyM=;
        b=qT+BJTLm4n429j8H4zc/Q9rqsj+PoSmGOXjTZ/C+JOEVFfylStDjguWHyk9lmez1+0
         RGsTz+vl/rFsm92F0kZCsaCqtNMUDPZPFtmDmEjZmUQq0/akx5cBR3Cd3mFKFdUW0ziJ
         fbL21kk7tnVt79VUDfJDwX0vgRkfLjNZR+CVlPerfU8rKfJidoFOrHcBMAoaKW4lNuwG
         UDh8O4uYTz1bbOKlZidSWPpikbXrt5euuuuxGCkOvpKForRVWjfHU66JIvAHmjyS1Szv
         UbdNlGgOK6jJsu0d2dDqgZjKZ9HDODQlAMDG/QjYbpJBZMUCeT+/1ZCjRCvMpgZLsnw+
         yuhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=SP7bBr9H6yAJpQpgXdluiHzYEyyCb5Tm/zhjuI1xuyM=;
        b=Q+4xmvA/hBGpdTAP2XEwoMc1MYl020J592KMfNtjBv1GvAPJDF0eKA6pBPdfB6ffuO
         W+e1+b/QiQaep5eJp4efwnWPVA+7W2J2dQiqJs1pUW3/iFgswYm24sVitKoUmXggPpQ+
         cvRBfteWPoiBtnwq3WPIY/ul/ZkI4AtZ8GOE5DEBQ7YSnq7hDOqeKxx9Hd0bY5VAIl6i
         SHpQ2ArRv6bR8xto/MB+hGrOasZLRTFUmlPTfHRLTcuH/OADJM+aeY4SJ8Wd1xLQvYnb
         SeUGhG6ZjgrLmO4Il9kxF+E1ww7J6InUCOhPhx6MrwUt3aDEx3SvqLV07zqPcP4QwdGK
         okPw==
X-Gm-Message-State: APjAAAXTQ3PfsKZ0ffsTf/0PoJg4iIAygqth+AxSgp8IT2E/tb024H3Z
        H+ZFWe3nZ+u1VVT8ZOMnIa7bSQ==
X-Google-Smtp-Source: APXvYqyGrODzKW20w/f6l/YF43SlNclKGtwdZbS249wQ/YutI4hizWJWbxTX+QYjTuFBORnyJxwv5A==
X-Received: by 2002:a17:90a:3268:: with SMTP id k95mr6540305pjb.48.1582242015549;
        Thu, 20 Feb 2020 15:40:15 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:511c:ebc0:d124:b4a0? ([2601:646:c200:1ef2:511c:ebc0:d124:b4a0])
        by smtp.gmail.com with ESMTPSA id o19sm4222728pjr.2.2020.02.20.15.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 15:40:14 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 10/12] mm: x86: Invoke hypercall when page encryption status is changed
Date:   Thu, 20 Feb 2020 15:40:12 -0800
Message-Id: <B5BDDC6D-4309-4A21-9F70-93BA64899C65@amacapital.net>
References: <CABayD+fTa=dtbb3E4+kgQkNqDHYUfJGJTUfN5PirBit6Xp4JeQ@mail.gmail.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, x86@kernel.org,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CABayD+fTa=dtbb3E4+kgQkNqDHYUfJGJTUfN5PirBit6Xp4JeQ@mail.gmail.com>
To:     Steve Rutherford <srutherford@google.com>
X-Mailer: iPhone Mail (17D50)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Feb 20, 2020, at 3:24 PM, Steve Rutherford <srutherford@google.com> wro=
te:
>=20
> =EF=BB=BFOn Thu, Feb 20, 2020 at 2:43 PM Brijesh Singh <brijesh.singh@amd.=
com> wrote:
>>=20
>>=20
>>=20
>>> On 2/20/20 2:43 PM, Steve Rutherford wrote:
>>> On Thu, Feb 20, 2020 at 7:55 AM Brijesh Singh <brijesh.singh@amd.com> wr=
ote:
>>>>=20
>>>>=20
>>>>=20
>>>> On 2/19/20 8:12 PM, Andy Lutomirski wrote:
>>>>>=20
>>>>>=20
>>>>>> On Feb 19, 2020, at 5:58 PM, Steve Rutherford <srutherford@google.com=
> wrote:
>>>>>>=20
>>>>>> =EF=BB=BFOn Wed, Feb 12, 2020 at 5:18 PM Ashish Kalra <Ashish.Kalra@a=
md.com> wrote:
>>>>>>>=20
>>>>>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>>>>>=20
>>>>>>> Invoke a hypercall when a memory region is changed from encrypted ->=

>>>>>>> decrypted and vice versa. Hypervisor need to know the page encryptio=
n
>>>>>>> status during the guest migration.
>>>>>>=20
>>>>>> One messy aspect, which I think is fine in practice, is that this
>>>>>> presumes that pages are either treated as encrypted or decrypted. If
>>>>>> also done on SEV, the in-place re-encryption supported by SME would
>>>>>> break SEV migration. Linux doesn't do this now on SEV, and I don't
>>>>>> have an intuition for why Linux might want this, but we will need to
>>>>>> ensure it is never done in order to ensure that migration works down
>>>>>> the line. I don't believe the AMD manual promises this will work
>>>>>> anyway.
>>>>>>=20
>>>>>> Something feels a bit wasteful about having all future kernels
>>>>>> universally announce c-bit status when SEV is enabled, even if KVM
>>>>>> isn't listening, since it may be too old (or just not want to know).
>>>>>> Might be worth eliding the hypercalls if you get ENOSYS back? There
>>>>>> might be a better way of passing paravirt config metadata across than=

>>>>>> just trying and seeing if the hypercall succeeds, but I'm not super
>>>>>> familiar with it.
>>>>>=20
>>>>> I actually think this should be a hard requirement to merge this. The h=
ost needs to tell the guest that it supports this particular migration strat=
egy and the guest needs to tell the host that it is using it.  And the guest=
 needs a way to tell the host that it=E2=80=99s *not* using it right now due=
 to kexec, for example.
>>>>>=20
>>>>> I=E2=80=99m still uneasy about a guest being migrated in the window wh=
ere the hypercall tracking and the page encryption bit don=E2=80=99t match. =
 I guess maybe corruption in this window doesn=E2=80=99t matter?
>>>>>=20
>>>>=20
>>>> I don't think there is a corruption issue here. Let's consider the belo=
w
>>>> case:
>>>>=20
>>>> 1) A page is transmitted as C=3D1 (encrypted)
>>>>=20
>>>> 2) During the migration window, the page encryption bit is changed
>>>>   to C=3D0 (decrypted)
>>>>=20
>>>> 3) #2 will cause a change in page table memory, thus dirty memory
>>>>   the tracker will create retransmission of the page table memory.
>>>>=20
>>>> 4) The page itself will not be re-transmitted because there was
>>>>   no change to the content of the page.
>>>>=20
>>>> On destination, the read from the page will get the ciphertext.
>>>>=20
>>>> The encryption bit change in the page table is used on the next access.=

>>>> The user of the page needs to ensure that data is written with the
>>>> correct encryption bit before reading.
>>>>=20
>>>> thanks
>>>=20
>>>=20
>>> I think the issue results from a slightly different perspective than
>>> the one you are using. I think the situation Andy is interested in is
>>> when a c-bit change and a write happen close in time. There are five
>>> events, and the ordering matters:
>>> 1) Guest dirties the c-bit in the guest
>>> 2) Guest dirties the page
>>> 3) Host userspace observes the c-bit logs
>>> 4) Host userspace observes the page dirty logs
>>> 5) Host transmits the page
>>>=20
>>> If these are reordered to:
>>> 3) Host userspace observes the c-bit logs
>>> 1) Guest dirties the c-bit in the guest
>>> 2) Guest dirties the page
>>> 4) Host userspace observes the page dirty logs
>>> 5) Host transmits the page (from the wrong c-bit perspective!)
>>>=20
>>> Then the host will transmit a page with the wrong c-bit status and
>>> clear the dirty bit for that page. If the guest page is not
>>> retransmitted incidentally later, then this page will be corrupted.
>>>=20
>>> If you treat pages with dirty c-bits as dirty pages, then you will
>>> check the c-bit logs later and observe the dirty c-bit and retransmit.
>>> There might be some cleverness around enforcing that you always fetch
>>> the c-bit logs after fetching the dirty logs, but I haven't convinced
>>> myself that this works yet. I think it might, since then the c-bits
>>> are at least as fresh as the dirty bits.
>>>=20
>>=20
>> Unlike the dirty log, the c-bit log maintains the complete state.
>> So, I think it is the Host userspace responsibility to ensure that it
>> either keeps track of any c-bit log changes since it last sync'ed.
>> During the migration, after pausing the guest it can get the recent
>> c-bit log and compare if something has changed since it last sync'ed.
>> If so, then retransmit the page with new c-bit state.
>>=20
>>> The main uncertainty that comes to mind for that strategy is if, on
>>> multi-vCPU VMs, the page dirtying event (from the new c-bit
>>> perspective) and the c-bit status change hypercall can themselves
>>> race. If a write from the new c-bit perspective can arrive before the
>>> c-bit status change arrives in the c-bit logs, we will need to treat
>>> pages with dirty c-bits as dirty pages.
>>>=20
>>=20
>> I believe if host userspace tracks the changes in the c-bit log since
>> it last synced then this problem can be avoided. Do you think we should
>> consider tracking the last sync changes in KVM or let the host userspace
>> handle it.
> Punting this off to userspace to handle works. If storing the old
> c-bit statuses in userspace becomes a memory issue (unlikely), we can
> fix that down the line.
>=20
> Andy, are your concerns about the raceyness of c-bit tracking resolved?

Probably, as long as the guest doesn=E2=80=99t play nasty games with trying t=
o read its own ciphertext.=
