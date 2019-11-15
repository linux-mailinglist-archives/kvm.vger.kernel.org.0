Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1FF6FDA7D
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfKOKFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:05:31 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53832 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727664AbfKOKFa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 05:05:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573812329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=cvfme1AzcNxoGDx6pFSOOBu1gZU4WXYpdcNR8/IWBAc=;
        b=BcvIHRMCqW/GUBxjNEiRH+vlk3XAjVjt+WHC8g+rS8cDB0wIM1YU3+2/koizVDS3gtsRy2
        54Px5CK0l7SM4QTOlJTllofL4gBC/5oAWNv/yBiBqHBvB2WhJq1mbrc6i1KXyd8aN+XbWk
        Y8REs2QV/Uka0UsAOFqiBWST87GAPew=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-WFKKNO4LMFWoKC6n7v--wA-1; Fri, 15 Nov 2019 05:05:28 -0500
Received: by mail-wr1-f69.google.com with SMTP id p4so7344243wrw.15
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 02:05:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EPis5QKVkSwgsTfXigrJ89vkfY5SjezGgbDiy1oaViM=;
        b=WlhTWsSWZvJ7lDx7uzD1i2/08iUgYy3HcLvPgjMW4VFfdHpgBqUOROP4KCcHHFGYZ5
         rNyEJ8P5zRXtRdZ1+qlw28WadV3oYEaJVkv3J+dh9CGDpj6Ur0F7c986pUEXPmEkHSBu
         AaIkGWmbDSnj4AyRK4Kv64PYknaLjtZxX5ORafTOplh6FoK35jKGT9b0OSrOhIXPdp6t
         hrT2KCOuXYt2ByNIU19FytOjK+owImTz4xxHRh6hMC94QGNyUzxOEAH2FBJrlzc+iy2f
         /t4Li/Al8y95bkBFOXt4mo3aIsaaGAjQXRpryj0sImW7GHrurHLezPLadwMlGNkmx9UM
         makw==
X-Gm-Message-State: APjAAAVdGZu4X+a0vqSqCKdqa3p87dl8UD/41IqpMnRvxhrFWPaIlzCg
        qMQb5MnJ6wTfjDme+bbddzfnTbx1KpLyBMhgqVz76hqJRB2z/cyfgPmod6yuFq5QgIwJL6chdPf
        ZfW+LlHgSjdPG
X-Received: by 2002:a05:600c:2383:: with SMTP id m3mr13066101wma.66.1573812326783;
        Fri, 15 Nov 2019 02:05:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqyJ0wkPAdXXktIYGuABy/5WbHWbp0QmKDfIpjL6STL1VEMTvNL1sS1UrBmrDzwWEzVNKBzStg==
X-Received: by 2002:a05:600c:2383:: with SMTP id m3mr13066061wma.66.1573812326428;
        Fri, 15 Nov 2019 02:05:26 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id b186sm8720442wmb.21.2019.11.15.02.05.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 02:05:25 -0800 (PST)
Subject: Re: [PATCH v2 06/16] x86/cpu: Clear VMX feature flag if VMX is not
 fully enabled
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
 <20191022000836.1907-1-sean.j.christopherson@intel.com>
 <20191025163858.GF6483@zn.tnic> <20191114183238.GH24045@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5aacaba0-76e2-9824-ebd4-fa510bce712d@redhat.com>
Date:   Fri, 15 Nov 2019 11:05:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191114183238.GH24045@linux.intel.com>
Content-Language: en-US
X-MC-Unique: WFKKNO4LMFWoKC6n7v--wA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/11/19 19:32, Sean Christopherson wrote:
>>> +=09=09=09pr_err_once("x86/cpu: VMX disabled, IA32_FEATURE_CONTROL MSR =
unsupported\n");
>=20
> My thought for having the print was to alert the user that something is
> royally borked with their system.  There's nothing the user can do to fix
> it per se, but it does indicate that either their hardware or the VMM
> hosting their virtual machine is broken.  So maybe be more explicit about
> it being a likely hardware/VMM issue?

Yes, good idea.

>>> +update_caps:
>>> +=09if (!cpu_has(c, X86_FEATURE_VMX))
>>> +=09=09return;
>>
>> If this test is just so we can save us the below code, I'd say remove it
>> for the sake of having less code in that function. The test is cheap and
>> not on a fast path so who cares if we clear an alrady cleared bit. But
>> maybe this evolves in the later patches...
>=20
> I didn't want to print the "VMX disabled by BIOS..." message if VMX isn't
> supported in the first place.  Later patches also add more code in this
> flow, but avoiding the print message is the main motiviation.

I agree on this too.

Paolo

>>> +
>>> +=09if ((tboot && !(msr & FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX)) ||
>>> +=09    (!tboot && !(msr & FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX)))=
 {
>>> +=09=09pr_err_once("x86/cpu: VMX disabled by BIOS (TXT %s)\n",
>>> +=09=09=09    tboot ? "enabled" : "disabled");
>>> +=09=09clear_cpu_cap(c, X86_FEATURE_VMX);
>>> +=09}
>>>  }
>>
>> --=20
>> Regards/Gruss,
>>     Boris.
>>
>> https://people.kernel.org/tglx/notes-about-netiquette
>=20

