Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 859C6FC425
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 11:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfKNK2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 05:28:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22076 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726505AbfKNK2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 05:28:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573727311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EFQvYPYJg4J0nEUN1I/pxNWunrwAO/84en8PpJ4myG8=;
        b=MtnQ/e1WBhfSPdtbo2rXkGREFnSEZY5zqwoWk35U+NOl57mr2qb75giRZLzxFPpGsz62nR
        Tt4+ErcBDY0T77oqes66rbUdnTaw8ho0OmytSHnxSRdxt5rJSMSKyeCQvIrsesOTFJ7Y0E
        pT6JH5vZvwmGFaXBkyOXvOXVutako2k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-oWQm8zjDMJuKuiIE9GMdAw-1; Thu, 14 Nov 2019 05:28:30 -0500
Received: by mail-wr1-f69.google.com with SMTP id c16so4139450wro.1
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 02:28:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=OLEZB8bUOZy709XKSr13fqe/JQ22WaDdec1GWexzC2k=;
        b=aHgXUrmBhDHKtDbf/IddWc9tcVcLL3o/L9Gr/UX4qLHWOThAIYiCLfu0bf10MbsEAT
         yHIFSDp1tByCXa7QAMH/MekDDC1w2SnEDadhjMMe5k0SEcd7tP32eb8A9PtXCp3u3tGF
         kfCRef/jf4wWQga9WOvMjbBr1GnuLn6VOMAWGmocE5hhMkyYJS/sRwJgMBeCjDPF6zXg
         WWTi2k25bNtQGUEOLBwvGGTd5ROJkn4ttonKg53jHm76Z/RJrUyM1ziEkWNb5kWq/fdQ
         OeHREc6RSjvqTFv/cYvrZeHAfSnvZ1+4VR7e1ihhK28xSwGwhQKhd9WWmwNnSUse4hVV
         +lIg==
X-Gm-Message-State: APjAAAWD4UUE1BHOA5cfrlzvfjd3Q1HwBQ8nOvpyeGQbJOEMPO0zGt0u
        SASy+6ZiFEqXdHf1BgeCiyetvPJjUrcugFr8g/WCcH1M9BAW5/krpfV6USKoS5MtjFzoUsRdLRU
        dLbWevR6gADYQ
X-Received: by 2002:adf:e5c5:: with SMTP id a5mr7734044wrn.103.1573727309729;
        Thu, 14 Nov 2019 02:28:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqwsYLtMghPxHaocCw/sQZ+g4HIzu9O9MkZCpblaOH+6ZixnUTO0kiIbHOFV+18oHvCbcS0aeA==
X-Received: by 2002:adf:e5c5:: with SMTP id a5mr7734015wrn.103.1573727309428;
        Thu, 14 Nov 2019 02:28:29 -0800 (PST)
Received: from [192.168.3.122] (p4FF23EA2.dip0.t-ipconnect.de. [79.242.62.162])
        by smtp.gmail.com with ESMTPSA id 17sm4878867wmg.19.2019.11.14.02.28.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 02:28:28 -0800 (PST)
From:   David Hildenbrand <david@redhat.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v1 1/4] s390x: saving regs for interrupts
Date:   Thu, 14 Nov 2019 11:28:28 +0100
Message-Id: <CD5636A0-3C33-4DC4-9217-68A00137E3F4@redhat.com>
References: <c7d6c21e-3746-b31a-aff9-d19549feb24c@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
In-Reply-To: <c7d6c21e-3746-b31a-aff9-d19549feb24c@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
X-Mailer: iPhone Mail (17A878)
X-MC-Unique: oWQm8zjDMJuKuiIE9GMdAw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Am 14.11.2019 um 11:11 schrieb Pierre Morel <pmorel@linux.ibm.com>:
>=20
> =EF=BB=BF
>> On 2019-11-13 17:12, Janosch Frank wrote:
>>> On 11/13/19 1:23 PM, Pierre Morel wrote:
>>> If we use multiple source of interrupts, for exemple, using SCLP consol=
e
>>> to print information while using I/O interrupts or during exceptions, w=
e
>>> need to have a re-entrant register saving interruption handling.
>>>=20
>>> Instead of saving at a static place, let's save the base registers on
>>> the stack.
>>>=20
>>> Note that we keep the static register saving that we need for the RESET
>>> tests.
>>>=20
>>> We also care to give the handlers a pointer to the save registers in
>>> case the handler needs it (fixup_pgm_int needs the old psw address).
>> So you're still ignoring the FPRs...
>> I disassembled a test and looked at all stds and it looks like printf
>> and related functions use them. Wouldn't we overwrite test FPRs if
>> printing in a handler?
>=20
> If printf uses the FPRs in my opinion we should modify the compilation op=
tions for the library.
>=20
> What is the reason for printf and related functions to use floating point=
?
>=20

Register spilling. This can and will be done.

Cheers.

> I will have a deeper look at this.
>=20
>=20
> Regards,
>=20
> Pierre
>=20
>=20
> --=20
> Pierre Morel
> IBM Lab Boeblingen
>=20

