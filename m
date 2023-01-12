Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECDE6687D6
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 00:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbjALXaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 18:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbjALXaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 18:30:00 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C699544F2
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 15:29:59 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id a30so14953535pfr.6
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 15:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SHCvT7wXhmjcdrY7ZciTjWwkM6hHEFK0c3kr7hoBtAI=;
        b=ctCtdF94uRfNtxj/svWJF4NSsYdcvFve3xy3/rA8RydeTZ7UjWoTdqG7u996S2CKI/
         TehMGCzH40R8wzRHE6l/Qg7QIpGqgUVlPVx5uj/NZKO5kr67dJpoaxvPHITVJXyFOLHv
         XI3GC6OsKxboq+O8C/C5L6uBMgxgdkOV1ixRpFq9POB1J6aJKL1Uv59KlorrracbhXqB
         8typO4QQIPx+dtHB1y8GmaHatYoZsRzusYcwur5NGt7FKgqOdZb2xyUU4Agsx6TE09Wv
         rHhRLzbjoiEUBC8V4zaAkLFmE/QRWlPIeog/ftIYZCpg54BM2sFvRygIwk8+bRY8eR4u
         eCug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SHCvT7wXhmjcdrY7ZciTjWwkM6hHEFK0c3kr7hoBtAI=;
        b=XTm8cmogIXahhUzxt7oTrVOyPqckb5/e771oBufxzZcBcN2MwkiQcRR7EZzhhekWXR
         eQPfcJuSKsE98FAImck7YVM4ts5o69GtBNaUB+mM5vvf2rB0zXdEBXzUIrmB/1DBiAuF
         jy1RBqd5FayDmAQzkSy5fcvLt89MswW4xEj5xTyg9mUt2YGX8zkH/kVtOFJ8DExivywy
         NjzRMJYiGVLSaLaJppYqLAV5X3iNSGnBMeERTY/tZBoN9OKdy6VUeJonTXiirwavLaLj
         /yFRdy9g9zzik1m10yvh9jxAO3td26puHwCt2/OOfY1O8g7OL+rSuYAx6RybjvLmV7Sr
         af/g==
X-Gm-Message-State: AFqh2kqfKBqUqXfyiT1tM/wP19BO9NqxTBOWSIVUjyoTWIHXiqnvbMRj
        T2UR3i55hUv6NcCFufD1+YO5DA==
X-Google-Smtp-Source: AMrXdXtbHXwlb7QCOirDHbnB+4X6BOCeHXpVkWh3Dab4zeJLYVt/vQh0K+r8OkjQmzQev1L+tq2hCQ==
X-Received: by 2002:a05:6a00:4514:b0:574:8995:c0d0 with SMTP id cw20-20020a056a00451400b005748995c0d0mr1044208pfb.1.1673566198371;
        Thu, 12 Jan 2023 15:29:58 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m190-20020a6258c7000000b005821c109cebsm7829231pfb.199.2023.01.12.15.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 15:29:56 -0800 (PST)
Date:   Thu, 12 Jan 2023 23:29:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, pbonzini@redhat.com,
        jgg@nvidia.com, cohuck@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfio: fix potential deadlock on vfio group lock
Message-ID: <Y8CX8YwT/T9v4U/D@google.com>
References: <20230112203844.41179-1-mjrosato@linux.ibm.com>
 <20230112140517.6db5b346.alex.williamson@redhat.com>
 <bce7912a-f904-b5a3-d234-c3e2c42d9e54@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bce7912a-f904-b5a3-d234-c3e2c42d9e54@linux.ibm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023, Matthew Rosato wrote:
> On 1/12/23 4:05 PM, Alex Williamson wrote:
> > On Thu, 12 Jan 2023 15:38:44 -0500
> > Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> >> @@ -344,6 +345,35 @@ static bool vfio_assert_device_open(struct vfio_device *device)
> >>  	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
> >>  }
> >>  
> >> +static bool vfio_kvm_get_kvm_safe(struct kvm *kvm)
> >> +{
> >> +	bool (*fn)(struct kvm *kvm);
> >> +	bool ret;
> >> +
> >> +	fn = symbol_get(kvm_get_kvm_safe);
> >> +	if (WARN_ON(!fn))

In a related vein to Alex's comments about error handling, this should not WARN.
WARNing during vfio_kvm_put_kvm() makes sense, but the "get" is somewhat blind.

> >> +		return false;
> >> +
> >> +	ret = fn(kvm);
> >> +
> >> +	symbol_put(kvm_get_kvm_safe);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static void vfio_kvm_put_kvm(struct kvm *kvm)
> >> +{
> >> +	void (*fn)(struct kvm *kvm);
> >> +
> >> +	fn = symbol_get(kvm_put_kvm);
> >> +	if (WARN_ON(!fn))
> >> +		return;
> >> +
> >> +	fn(kvm);
> >> +
> >> +	symbol_put(kvm_put_kvm);
> >> +}
