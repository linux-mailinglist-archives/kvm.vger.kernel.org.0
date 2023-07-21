Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E1B75C647
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 14:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjGUMAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 08:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjGUMAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 08:00:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569F11727
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 04:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689940782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Y7rbnaDJbn/YejSF4mQVA8Z4grlfMZHjKPnDFxLZ8A=;
        b=NLYxJ/tI375ddfrYE69u4PU4Z9h7i6tOguCLsIe+/EncQBl2Aqsf93Gj2dpLFHHmIJWLvd
        wEHK9+sHYSWQpfB86rX4TB+P5e6nKB+99bnGoy9jC96Rwt1F2pOlKeFgF426rwViuud1tV
        rJFa43qXP2DG3tN66TNOfIOxNbBopgE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-v2Io7zt6ODCqDKu6f9EDjA-1; Fri, 21 Jul 2023 07:59:41 -0400
X-MC-Unique: v2Io7zt6ODCqDKu6f9EDjA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-993c2d9e496so119392666b.0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 04:59:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689940780; x=1690545580;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Y7rbnaDJbn/YejSF4mQVA8Z4grlfMZHjKPnDFxLZ8A=;
        b=VFzPjDZNNgAEM3kGclca1CK/CBmfX6Uxar0vgwlOCfxHGAEIBSv+3ZqJrUvoCiAY7H
         LdFJwGxQVNLbUb2iz2dDveiAhbseAtisyFQUHxErJ4SG9v3tFxYcu5LrJmNZ82ZWYDZe
         bJceocFW8xssrDj4doIfJXxcas0iRiLdhiD2EIrUy5vpkWLmHotdQ9pHv+1u9hFb9Qi5
         zGshiNqdlbxEYg3OZw11Btv5581u9uQkNUgOrLJcz3LlbqLBg6y41IEKjC06TGkG3oEI
         cu9WPs6L+fCKlvze+khKS1VCI/P5uFTQxxoLae9FqvU4voHLqRw/1y94/gbjgpcBHecj
         Qohg==
X-Gm-Message-State: ABy/qLbK3sCRC9+BPBDu0I5ORMFZI8zETS0LqhBJHjEUXac5mp9vKeTl
        7OVKytSihs8KLmxQM57CgkmMXQ8lmNynyxtJ1OTPNcyRoHONZ2xc4e/QKsWs0SIoJyNpJNLW+MH
        By/At8ABNfAg0
X-Received: by 2002:a17:906:2da:b0:994:54af:e282 with SMTP id 26-20020a17090602da00b0099454afe282mr1360639ejk.10.1689940780007;
        Fri, 21 Jul 2023 04:59:40 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEk/l1rT7vVGyK6B+M0/vN6OF6CipTv2G0AE0UWGqg9sgFPNWcoUSGmc+Sw2v1G9OPem3PIcQ==
X-Received: by 2002:a17:906:2da:b0:994:54af:e282 with SMTP id 26-20020a17090602da00b0099454afe282mr1360600ejk.10.1689940779630;
        Fri, 21 Jul 2023 04:59:39 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id um15-20020a170906cf8f00b00992b3ea1ee3sm2078970ejb.159.2023.07.21.04.59.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 04:59:38 -0700 (PDT)
Message-ID: <6118063e-5c91-acc4-129f-3bacc19f25ce@redhat.com>
Date:   Fri, 21 Jul 2023 13:59:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v11 09/29] KVM: x86: Disallow hugepages when memory
 attributes are mixed
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
References: <20230718234512.1690985-1-seanjc@google.com>
 <20230718234512.1690985-10-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230718234512.1690985-10-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/19/23 01:44, Sean Christopherson wrote:
> +static bool range_has_attrs(struct kvm *kvm, gfn_t start, gfn_t end,
> +			    unsigned long attrs)
> +{
> +	XA_STATE(xas, &kvm->mem_attr_array, start);
> +	unsigned long index;
> +	bool has_attrs;
> +	void *entry;
> +
> +	rcu_read_lock();
> +
> +	if (!attrs) {
> +		has_attrs = !xas_find(&xas, end);
> +		goto out;
> +	}
> +
> +	has_attrs = true;
> +	for (index = start; index < end; index++) {
> +		do {
> +			entry = xas_next(&xas);
> +		} while (xas_retry(&xas, entry));
> +
> +		if (xas.xa_index != index || xa_to_value(entry) != attrs) {
> +			has_attrs = false;
> +			break;
> +		}
> +	}
> +
> +out:
> +	rcu_read_unlock();
> +	return has_attrs;
> +}
> +

Can you move this function to virt/kvm/kvm_main.c?

Thanks,

Paolo

