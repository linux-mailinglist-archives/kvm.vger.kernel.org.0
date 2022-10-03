Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D717F5F37CB
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 23:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiJCVa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 17:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiJCV36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 17:29:58 -0400
X-Greylist: delayed 1021 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 03 Oct 2022 14:24:26 PDT
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C24250518;
        Mon,  3 Oct 2022 14:24:26 -0700 (PDT)
Received: from [127.0.0.1] ([73.223.250.219])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 293L1MEs3109337
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 3 Oct 2022 14:01:22 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 293L1MEs3109337
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2022090501; t=1664830885;
        bh=5zHAz69mkxip2bzOLRJ4yt3No7BYKjAs2m4UMY86+jU=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=oykLJvyx1Q7ObEI2DH5ERO/25eTiZzFZJgvAbC877waEJ3rI15d4aEdEhxqbJeO9A
         9mAtYzKq8KzgRaHdsZgLzcZ2FyOyJwtGOC7Mz+CWLiAoLfbb5WWY5pApSxlkZqx2kg
         +jdO0xgF1Zn08mAVfDnpAfBMkCcXHyW5VxanswAVTHLqQKoZ+Zkpg3OXttXf7gowum
         15bO9ANhBUQRzE2ffGGoHuLuA3pDNZDMyqSFToe9GidZCxmVEF1Y4Vhvw77jGJ5haa
         Ryz+0xxNJVgfA4mrSDmKj9XJmZNlHN+9On7utZ6oZSi0H5AyXYqm2nhWCl+Q2Kqooh
         0qiZDnZqQsadQ==
Date:   Mon, 03 Oct 2022 14:01:20 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ajay Kaher <akaher@vmware.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        "er.ajay.kaher@gmail.com" <er.ajay.kaher@gmail.com>,
        "willy@infradead.org" <willy@infradead.org>,
        Nadav Amit <namit@vmware.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jailhouse-dev@googlegroups.com" <jailhouse-dev@googlegroups.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "acrn-dev@lists.projectacrn.org" <acrn-dev@lists.projectacrn.org>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH v2] x86/PCI: Prefer MMIO over PIO on all hypervisor
User-Agent: K-9 Mail for Android
In-Reply-To: <87tu4l9cfm.fsf@redhat.com>
References: <9FEC6622-780D-41E6-B7CA-8D39EDB2C093@vmware.com> <87zgf3pfd1.fsf@redhat.com> <B64FD502-E794-4E94-A267-D690476C57EE@vmware.com> <87tu4l9cfm.fsf@redhat.com>
Message-ID: <E522EECC-D20D-4A69-8A44-9CF2B36E2A29@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On October 3, 2022 8:03:41 AM PDT, Vitaly Kuznetsov <vkuznets@redhat=2Ecom>=
 wrote:
>Ajay Kaher <akaher@vmware=2Ecom> writes:
>
>>> =EF=BB=BFOn 13/09/22, 7:05 PM, "Vitaly Kuznetsov" <vkuznets@redhat=2Ec=
om> wrote:
>>>>
>>>> Thanks Vitaly for your response=2E
>>>>
>>>> 1=2E we have multiple objects of struct pci_raw_ops, 2=2E adding 'pri=
ority' field to struct pci_raw_ops
>>>> doesn't seems to be appropriate as need to take decision which object=
 of struct pci_raw_ops has
>>>> to be used, not something with-in struct pci_raw_ops=2E
>>>
>>> I'm not sure I follow, you have two instances of 'struct pci_raw_ops'
>>> which are called 'raw_pci_ops' and 'raw_pci_ext_ops'=2E What if you do
>>> something like (completely untested):
>>>
>>> diff --git a/arch/x86/include/asm/pci_x86=2Eh b/arch/x86/include/asm/p=
ci_x86=2Eh
>>> index 70533fdcbf02=2E=2Efb8270fa6c78 100644
>>> --- a/arch/x86/include/asm/pci_x86=2Eh
>>> +++ b/arch/x86/include/asm/pci_x86=2Eh
>>> @@ -116,6 +116,7 @@ extern void (*pcibios_disable_irq)(struct pci_dev =
*dev);
>>> extern bool mp_should_keep_irq(struct device *dev);
>>>
>>> struct pci_raw_ops {
>>> +       int rating;
>>>          int (*read)(unsigned int domain, unsigned int bus, unsigned i=
nt devfn,
>>>                                                int reg, int len, u32 *=
val);
>>>          int (*write)(unsigned int domain, unsigned int bus, unsigned =
int devfn,
>>> diff --git a/arch/x86/pci/common=2Ec b/arch/x86/pci/common=2Ec
>>> index ddb798603201=2E=2Ee9965fd11576 100644
>>> --- a/arch/x86/pci/common=2Ec
>>> +++ b/arch/x86/pci/common=2Ec
>>> @@ -40,7 +40,8 @@ const struct pci_raw_ops *__read_mostly raw_pci_ext_=
ops;
>>>  int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int =
devfn,
>>>                                                 int reg, int len, u32 =
*val)
>>> {
>>> -       if (domain =3D=3D 0 && reg < 256 && raw_pci_ops)
>>> +       if (domain =3D=3D 0 && reg < 256 && raw_pci_ops &&
>>> +           (!raw_pci_ext_ops || raw_pci_ext_ops->rating <=3D raw_pci_=
ops->rating))
>>>                 return raw_pci_ops->read(domain, bus, devfn, reg, len,=
 val);
>>>         if (raw_pci_ext_ops)
>>>                 return raw_pci_ext_ops->read(domain, bus, devfn, reg, =
len, val);
>>> @@ -50,7 +51,8 @@ int raw_pci_read(unsigned int domain, unsigned int b=
us, unsigned int devfn,
>>>  int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int=
 devfn,
>>>                                                 int reg, int len, u32 =
val)
>>> {
>>> -       if (domain =3D=3D 0 && reg < 256 && raw_pci_ops)
>>> +       if (domain =3D=3D 0 && reg < 256 && raw_pci_ops &&
>>> +           (!raw_pci_ext_ops || raw_pci_ext_ops->rating <=3D raw_pci_=
ops->rating))
>>>                 return raw_pci_ops->write(domain, bus, devfn, reg, len=
, val);
>>>          if (raw_pci_ext_ops)
>>>                 return raw_pci_ext_ops->write(domain, bus, devfn, reg,=
 len, val);
>>>
>>> and then somewhere in Vmware hypervisor initialization code
>>> (arch/x86/kernel/cpu/vmware=2Ec) you do
>>>
>>>  raw_pci_ext_ops->rating =3D 100;
>>
>> Thanks Vitaly, for your review and helping us to improve the code=2E
>>
>> I was working to make changes as you suggested, but before sending v3 w=
ould like to
>> discuss on following:
>>
>> If we add rating with-in struct pci_raw_ops then we can't have pci_mmcf=
g as const,
>> and following change is must in arch/x86/pci/mmconfig_64=2Ec:
>>
>> -const struct pci_raw_ops pci_mmcfg =3D {
>> +struct pci_raw_ops pci_mmcfg =3D {
>>  	=2Eread =3D		pci_mmcfg_read,
>>  	=2Ewrite =3D	pci_mmcfg_write,
>> };
>>
>> So to avoid this change, is it fine to have global bool prefer_raw_pci_=
ext_ops?
>>
>> And raw_pci_read() will have following change:
>>
>> -	if (domain =3D=3D 0 && reg < 256 && raw_pci_ops)
>> +	if (domain =3D=3D 0 && reg < 256 && raw_pci_ops &&
>> +	     (!prefer_raw_pci_ext_ops ||  !raw_pci_ext_ops)
>>
>
>Not my but rather PCI maintainer's call but IMHO dropping 'const' is
>better, introducing a new global var is our 'last resort' and should be
>avoided whenever possible=2E Alternatively, you can add a
>raw_pci_ext_ops_preferred() function checking somethin within 'struct
>hypervisor_x86' but I'm unsure if it's better=2E
>
>Also, please check Alex' question/suggestion=2E
>
>=2E=2E=2E
>

Could this be ro_after_init?
