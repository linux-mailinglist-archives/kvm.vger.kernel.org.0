Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DE84347D1
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 11:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhJTJX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 05:23:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229757AbhJTJX0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 05:23:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634721672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2FTm4hB908w4qRaSg9DMpXYtjbgTyekA3fgrUlsXzrg=;
        b=C68uORIATUmJalh3etreSPz+xULkkP7i2MaSXMLvQ9wTdu6N5dA7fRlY2Y83os9Bj+VpFC
        ghe44IZdDuqSXiQ9Wr3hWIG4x9ecT2ID7Hr6UsmU1T38Zf6ymoob+xTaTKuEhKx/vBKyJK
        OCaTxwAJEAlybbdBUuh7OwtOxAp0FYQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-JWUlGKL2NkuxflyTr-QCqg-1; Wed, 20 Oct 2021 05:21:11 -0400
X-MC-Unique: JWUlGKL2NkuxflyTr-QCqg-1
Received: by mail-wm1-f70.google.com with SMTP id 128-20020a1c0486000000b0030dcd45476aso3875078wme.0
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 02:21:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2FTm4hB908w4qRaSg9DMpXYtjbgTyekA3fgrUlsXzrg=;
        b=FRU7gR+Sjiw2v5vuUS/UmHs+KVQ5rAsHtkXO/b4A6gpWvQE33NywWXMlEdzXN4gww8
         aU5DGZl/Y6ZzCbYqwTpi3SDueQS/5xC2O7ycpItUkxHcqA6c+laRqi540P7u9QAjdorK
         VmVJHM6Q9SxBYMlvT3mVBUvDO/6NpmGpq2yP0lOBzIzHtNkKl4GofSEnBElXPdt//eCw
         CIP+Pre+OeEMRmclW6PBCdEm/6332oAFWXuq2MRMYpIRX1tJDGqukvgjvZLyVA6SZeOA
         Cok/rrQkcV7xSMMQ7CEo90s8Nd1HkYj0PybgXJn9mTj5qiTnIcov9PrOQVQCOEl8J/i2
         q7HQ==
X-Gm-Message-State: AOAM5338VVSfj6kjPoP+RaUgArtLk+mP+KKs8Iy5pcIOZnv1YKfylSo8
        4hNuYqar/+gHki571A56CzlqYfNjK1hNE7x347150Y7V4EIpDS9o3uR9yVTzC0VmAidVokjEUCb
        J3rTlJ5Esn5aY
X-Received: by 2002:adf:a78a:: with SMTP id j10mr51574908wrc.105.1634721669583;
        Wed, 20 Oct 2021 02:21:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8K9SqjdnLTu+AtEqO80YHThHgWgyLObp8OQmz0jj1gpserb3ZGDdiVUyHxxkUmPdPJmBTMQ==
X-Received: by 2002:adf:a78a:: with SMTP id j10mr51574880wrc.105.1634721669335;
        Wed, 20 Oct 2021 02:21:09 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id z1sm1517895wre.21.2021.10.20.02.21.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 02:21:08 -0700 (PDT)
Message-ID: <dd914336-efca-e74e-521d-dbf57ad4eba3@redhat.com>
Date:   Wed, 20 Oct 2021 11:21:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: cleanup allocation of rmaps and page tracking data
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, David Stevens <stevensd@chromium.org>
References: <20211018175333.582417-1-pbonzini@redhat.com>
 <6eb45cc24c433f5620f08d7bcd0c9cc179b696e8.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <6eb45cc24c433f5620f08d7bcd0c9cc179b696e8.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/21 21:28, Maxim Levitsky wrote:
>> +static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
>> +{
>> +	return !kvm->arch.tdp_mmu_enabled || kvm_shadow_root_alloced(kvm);
>>   }
> Note that this breaks 32 bit build - kvm->arch.tdp_mmu_enabled is not defined.

Indeed, the right test is is_tdp_mmu_enabled(kvm).

Paolo

