Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310643230AC
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 19:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbhBWSZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 13:25:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:49828 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233837AbhBWSZu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 13:25:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614104703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DyO1mfvHjHSAG9XQ7b42ZfYJ99hqQfhvvyq5UVVCWzA=;
        b=OCZEepjEd8nPAA5yXaOMYt7CXqXhFbY2Mt80my9GaJ1wxG8ssZG+l72iGL2//6tO0F/gbF
        eUQs/+2nH2eLaiAFZVT6bVg4XJmCC1zyQAeNKWTfUiwWs6SK6RvXrG0Gf30PWt3dcp0U0j
        cqZV7p2WJoAiw5OI0RKtAQzMlTw6k8A=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 435CAAFF3;
        Tue, 23 Feb 2021 18:25:03 +0000 (UTC)
Date:   Tue, 23 Feb 2021 19:24:55 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     tj@kernel.org, thomas.lendacky@amd.com, brijesh.singh@amd.com,
        jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com,
        hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, rientjes@google.com, dionnaglaze@google.com,
        kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] cgroup: sev: Add misc cgroup controller
Message-ID: <YDVIdycgk8XL0Zgx@blackbook>
References: <20210218195549.1696769-1-vipinsh@google.com>
 <20210218195549.1696769-2-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vD1CgIgdIbjxQfR1"
Content-Disposition: inline
In-Reply-To: <20210218195549.1696769-2-vipinsh@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--vD1CgIgdIbjxQfR1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 18, 2021 at 11:55:48AM -0800, Vipin Sharma <vipinsh@google.com> wrote:
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> [...]
> +#ifndef CONFIG_KVM_AMD_SEV
> +/*
> + * When this config is not defined, SEV feature is not supported and APIs in
> + * this file are not used but this file still gets compiled into the KVM AMD
> + * module.
I'm not familiar with the layout of KVM/SEV compile targets but wouldn't
it be simpler to exclude whole svm/sev.c when !CONFIG_KVM_AMD_SEV?

> +++ b/kernel/cgroup/misc.c
> [...]
> +/**
> + * misc_cg_set_capacity() - Set the capacity of the misc cgroup res.
> + * @type: Type of the misc res.
> + * @capacity: Supported capacity of the misc res on the host.
> + *
> + * If capacity is 0 then the charging a misc cgroup fails for that type.
> + *
> + * The caller must serialize invocations on the same resource.
> + *
> + * Context: Process context.
> + * Return:
> + * * %0 - Successfully registered the capacity.
> + * * %-EINVAL - If @type is invalid.
> + * * %-EBUSY - If current usage is more than the capacity.
When is this function supposed to be called? At boot only or is this
meant for some kind of hot unplug functionality too?

> +int misc_cg_try_charge(enum misc_res_type type, struct misc_cg **cg,
> +		       unsigned int amount)
> [...]
> +		new_usage = atomic_add_return(amount, &res->usage);
> +		if (new_usage > res->max ||
> +		    new_usage > misc_res_capacity[type]) {
> +			ret = -EBUSY;
I'm not sure the user of this resource accounting will always be able to
interpret EBUSY returned from depths of the subsystem.
See what's done in pids controller in order to give some useful
information about why operation failed.

> +			goto err_charge;
> +		}
> +
> +		// First one to charge gets a reference.
> +		if (new_usage == amount)
> +			css_get(&i->css);
1) Use the /* comment */ style.
2) You pin the whole path from task_cg up to root (on the first charge).
That's unnecessary since children reference their parents.
Also why do you get the reference only for the first charger? While it
may work, it seems too convoluted to me.
It'd be worth documenting what the caller can expect wrt to ref count of
the returned misc_cg.

Thanks,
Michal

--vD1CgIgdIbjxQfR1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmA1SHcACgkQia1+riC5
qSivUg/9EiijSYjdM27m519sTtNmnf7A8HESAA+AKHoxAzNGS5gX0erx4CzDhaxD
7dylOAQN3muEl/C56sin5CbaiJ5vKnwqYdqJur3cUAVo5N5mpG9bsnLRnWMfFkCo
VgczMAeS6e/r1FLfiSujGtdxZOUJCgl51tcCKNM5z+yd5UObi8IAfbgkwStAmFrq
9/NC93xbJ97oCNTPgHMQ84sMXMSay4ExMKoa7CLpC/Y27wgpa03zIQ3wpgezGTiT
UjXvkKcXl0FJRF9t+jZboTBEEDnjLGb1HvmSzkI8hFCcNHbZhNAcOt1QtlI70maK
VFU0hDddLovzqDkJ6oo2Hkx9wilMz8xb8SUgLTGK6w+HMjMfosfwkSAl2NTM3Q9T
cHtPdE3c00rnjX1x/CS2iCgeFOHNQvig/ZVZ8E5U9xLyX/XlHaDOIbjtdM/fWYyv
9HkUY8I6AlP+LspXib1XtaDqBx4DSD9nAbLPS0cohAktu8Qf6GrKFzAXQCMtAt9b
eVtu6+ZemHL3k6R07HiUCdCpqxrpevuv5vrnvPJV3vcX986zAvDloB04nqPg3iaZ
/keECDl0t5graoHiW0QM8c3bNOEzx33KH7dK4EPvAIM1xE4T1eW3vzjDdwGG/ExN
aTVcS7Aac+bhaDXbXlLW3AgPrdrs1hnYBx/mflGlZzoA0ZBHkGE=
=Kfse
-----END PGP SIGNATURE-----

--vD1CgIgdIbjxQfR1--
