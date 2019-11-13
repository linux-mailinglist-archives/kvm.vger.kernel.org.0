Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C69FB4B5
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 17:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfKMQNA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 11:13:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30406 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728279AbfKMQM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 11:12:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573661578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=rjTHIw0K5fi36MGDsTa1GmoiIxE1T9MyNtMom/3KwVA=;
        b=FwKop5RAGSw/F6BcHqF/x/Cgh/GiD6QXB6Ep4TcQ+e/Ts2TSg1X3ZgItVQSobSBkaORnKU
        PTH1ScQN608yaSZHykOOvSczfwzIhLO8sZ5/kYEFJlGdMa9WmhUvqkD+e1phpBEhH3v1jH
        94PTjZvByyfiqCWbYcD0Rra0ka+fcE0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-TaapeSoRMWukkxmFNG3FrQ-1; Wed, 13 Nov 2019 11:12:55 -0500
Received: by mail-wm1-f71.google.com with SMTP id m68so1620830wme.7
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 08:12:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+fLK+24+bjlkMrv2uMDPls8T1fzyu9EXJDfcpce5Yy8=;
        b=tlRyJBR1fCR0s8ySbTz3Qu88zgu5S2Dhbhiwr/E5UpvYRkWO3sK22opd1mNuZxcIRj
         07+w0LGDNs9MtAhk8/pcq2Qo02LutrmwXntb3e9wfadJZGAvgSl10H7+QGNcTm7AZ9LQ
         BmaKYEobpE9Gip+OdUF2Mq7QdFnXzabdj31wfVy3btgYjOJ7WMrurlL/Q0PCEck0pQZM
         FfpWaTOi5AnLIRQWNJ5p0yav0vg7edJGvCcLDCieOcyszOy559ueyE7Lv4FSM7v46Eif
         X9cmMlgecHmMOYwtsLcbRz3X2MoLKQiSO/5BCziyX+UOdwouCsVKtsoshT0TtnViMoj+
         3DBg==
X-Gm-Message-State: APjAAAV60FWIrWnBJ9BQA5NafWMOjMWdtmzj6AeMcyNUiNYgUJtMMA2l
        tVqxzubpUCg+xWCzc3zaYC35LPH9L2bMhfFK2wrukhRW22G6zcF9QvTrGwoyfNVmfKKciE9o8e9
        mBq3iPcuT79cB
X-Received: by 2002:a1c:2e8f:: with SMTP id u137mr3590078wmu.105.1573661574069;
        Wed, 13 Nov 2019 08:12:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqyJFbEYLRYKFckNqLkQNRQkm4Pm3Lw3OAJiin3dxHR1ITVV5P/LjDOujbs1lDta06CMREr4ZQ==
X-Received: by 2002:a1c:2e8f:: with SMTP id u137mr3590048wmu.105.1573661573757;
        Wed, 13 Nov 2019 08:12:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:64a1:540d:6391:74a9? ([2001:b07:6468:f312:64a1:540d:6391:74a9])
        by smtp.gmail.com with ESMTPSA id w12sm2743075wmi.17.2019.11.13.08.12.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2019 08:12:53 -0800 (PST)
Subject: Re: [PATCH] KVM: Forbid /dev/kvm being opened by a compat task when
 CONFIG_KVM_COMPAT=n
To:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20191113160523.16130-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8c478d7a-5d19-083f-f241-f9e573253a1f@redhat.com>
Date:   Wed, 13 Nov 2019 17:12:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191113160523.16130-1-maz@kernel.org>
Content-Language: en-US
X-MC-Unique: TaapeSoRMWukkxmFNG3FrQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/11/19 17:05, Marc Zyngier wrote:
> On a system without KVM_COMPAT, we prevent IOCTLs from being issued
> by a compat task. Although this prevents most silly things from
> happening, it can still confuse a 32bit userspace that is able
> to open the kvm device (the qemu test suite seems to be pretty
> mad with this behaviour).
>=20
> Take a more radical approach and return a -ENODEV to the compat
> task.
>=20
> Reported-by: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/kvm_main.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 543024c7a87f..1243e48dc717 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -122,7 +122,13 @@ static long kvm_vcpu_compat_ioctl(struct file *file,=
 unsigned int ioctl,
>  #else
>  static long kvm_no_compat_ioctl(struct file *file, unsigned int ioctl,
>  =09=09=09=09unsigned long arg) { return -EINVAL; }
> -#define KVM_COMPAT(c)=09.compat_ioctl=09=3D kvm_no_compat_ioctl
> +
> +static int kvm_no_compat_open(struct inode *inode, struct file *file)
> +{
> +=09return is_compat_task() ? -ENODEV : 0;
> +}
> +#define KVM_COMPAT(c)=09.compat_ioctl=09=3D kvm_no_compat_ioctl,=09\
> +=09=09=09.open=09=09=3D kvm_no_compat_open
>  #endif
>  static int hardware_enable_all(void);
>  static void hardware_disable_all(void);
>=20

Queued, thanks.

Paolo

