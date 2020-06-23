Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5D720453E
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 02:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731416AbgFWAX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 20:23:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52708 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730679AbgFWAX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 20:23:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592871837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NahUiJQzDT4T5YVMvJMh+ukesK3KvitTEMq94zE6mM8=;
        b=b4Ul+/QXGs2pDgDkhSJ4ec2RXVyAhSQCu4uORcUJVlpVhyI70SIdhOTabnl5tgn67OqT+Z
        iqJqUtLlotjqbRhpkrVT7Dkmpjr6fKnK8yw4PRSw0E8CmkiCC03GEEUU70/DakqxR+HxWH
        gCuPmZc9qi7bzI0l3k7o2xmZxm/2HZ8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-wySqoQCFPCSeeIMEzQ9IOQ-1; Mon, 22 Jun 2020 20:23:56 -0400
X-MC-Unique: wySqoQCFPCSeeIMEzQ9IOQ-1
Received: by mail-wr1-f71.google.com with SMTP id g14so5752643wrp.8
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 17:23:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NahUiJQzDT4T5YVMvJMh+ukesK3KvitTEMq94zE6mM8=;
        b=fuuOzALJ+PT8p0z/FS/hnWneET3aRB+4+9QdVKkXShxjNxuobrqvDh7xpUEwWOGgzE
         mJhv5KNmWyXWOrsnTB0teojExYzUVSZU1dbdZkFatXcpSqXKemY2HWB8HuXOjYd2MSko
         Tvk+cdSFHf63PmKIXegedTDl5s9TkApAuMKpySYCD9SqDa7JhSuKGIC584nv6chvmCeN
         zUwJHhGah2dv4CYHztnCVySTon+Yr+ea7Iw+DLuQEXZeVBH3EG4Pcxh5sMcqVBa7LBq+
         a+UAVPG+QMTiRrjdv239KJuY2Q1K3XxXmiloOvwSeEYVfJqQ7mXTw4R13j8IacaZcXdb
         CXrw==
X-Gm-Message-State: AOAM53269tRT6nFTNxdMudXeQZA2r/5rxNNIwgyUYfMWlWwKrZwnid/b
        eLJ8UoFOyoIigkvf/WTWTUX5YikwGFWqyt/a9eTR4iSxTjcxKsW/SCmvVID6d0avUil5VNFavi+
        7g/zbVOM0MnyU
X-Received: by 2002:a1c:9d07:: with SMTP id g7mr9834355wme.160.1592871834867;
        Mon, 22 Jun 2020 17:23:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9X5tQCXeIJHnr5kL8QlKHGaaTuNECyqcOl4C6xBySPZ8QwnGYQom1PDI3LxchqhObFc9j0g==
X-Received: by 2002:a1c:9d07:: with SMTP id g7mr9834332wme.160.1592871834573;
        Mon, 22 Jun 2020 17:23:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fd64:dd90:5ad5:d2e1? ([2001:b07:6468:f312:fd64:dd90:5ad5:d2e1])
        by smtp.gmail.com with ESMTPSA id h14sm4124267wrt.36.2020.06.22.17.23.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 17:23:54 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Don't put invalid SPs back on the list of
 active pages
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200622191850.8529-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d1916978-6efb-2839-d45a-c39ff2f6dc1f@redhat.com>
Date:   Tue, 23 Jun 2020 02:23:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200622191850.8529-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/20 21:18, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index fdd05c233308..fa5bd3f987dd 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2757,10 +2757,13 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
>  	if (!sp->root_count) {
>  		/* Count self */
>  		(*nr_zapped)++;
> -		list_move(&sp->link, invalid_list);
> +		if (sp->role.invalid)
> +			list_add(&sp->link, invalid_list);
> +		else
> +			list_move(&sp->link, invalid_list);

It's late here, but I think this part needs a comment anyway...

Paolo

