Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6FA75ED92
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 10:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbjGXI37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 04:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjGXI35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 04:29:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D892134
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 01:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690187341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=juUjWpa2JI7RTYhcunGhZz1VwOp9DGNQea7nBpEHlNU=;
        b=QxoLsk7mkPaE3j2zvfcTkqQJdttO8XLiLwZ20DJjcJ8Dy52mRBmpKeVLsJuFhiUWLuGaxl
        987ds7pOfm7+nkl9YeASAsXX2XTC0NwqrBUfyF4kDHkj3P2MisyGxSvAgBFo0pbgfwwjkx
        nxPO/G9E0/VBbG6mOtG30+Z8MRQ0nus=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-gY9U7bu0N9mAjdJ-g2H8hg-1; Mon, 24 Jul 2023 04:29:00 -0400
X-MC-Unique: gY9U7bu0N9mAjdJ-g2H8hg-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2b95d92116dso34882621fa.3
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 01:29:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690187339; x=1690792139;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=juUjWpa2JI7RTYhcunGhZz1VwOp9DGNQea7nBpEHlNU=;
        b=WIhaVXqda8TQehXVN76/Vuy75gOT/e7YFjQpS6Mx06gxYRHhBGDo3nLJTSM9/g78+E
         q+orkcxobkC8MEcRktbL+FoWQ8hjV5L5UNeryw2ORWhu8x4Rt8QrCM386vsBgVAb7yNE
         94cl21igkutu5T6l8JQjwH+dnV/9gJ0brSydsX0rS9AVVKonU8cRq7Lap2SxJlYwK/nP
         l9cDyTHDdQQF3kq0cFL49zrSBUakBahxa6PDVwg3n10x0do8KvRBzzlfyLd2hrTFFTgO
         /1CR8FkB5KdvuKP0fiGlc4g6f/YQlD/5TZo3ZBZL2Bh+fNpXyNeYtVvkvrLxvu3PtGGq
         G+zQ==
X-Gm-Message-State: ABy/qLYZIndHZK7xinxYYGGC/cg+Qpygr4luXmqR34G/W6chqXKoWUIc
        yy5IiaC12s+zAWmB84v4Ba+gwwQ7Bz67j5CDkKapMsjGQfpD9bq1DpW3cNORJK44WbdNcEWuEGA
        xCQMbgo2XGWCi
X-Received: by 2002:a2e:9556:0:b0:2b8:3797:84e4 with SMTP id t22-20020a2e9556000000b002b8379784e4mr5537008ljh.18.1690187339033;
        Mon, 24 Jul 2023 01:28:59 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEPImP9LxpC4V4IiV0Qbz2b0sQNi/ieeqXGoS0C6c6DyTzijmwojb+7Q3nGHs3QwkHU5zCWZg==
X-Received: by 2002:a2e:9556:0:b0:2b8:3797:84e4 with SMTP id t22-20020a2e9556000000b002b8379784e4mr5536993ljh.18.1690187338677;
        Mon, 24 Jul 2023 01:28:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f45:d000:62f2:4df0:704a:e859? (p200300d82f45d00062f24df0704ae859.dip0.t-ipconnect.de. [2003:d8:2f45:d000:62f2:4df0:704a:e859])
        by smtp.gmail.com with ESMTPSA id y19-20020a05600c20d300b003fd2d33f972sm5371895wmm.38.2023.07.24.01.28.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 01:28:58 -0700 (PDT)
Message-ID: <80ab8ed9-ec6e-2bfa-62d6-da63d98c03e7@redhat.com>
Date:   Mon, 24 Jul 2023 10:28:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 4/6] KVM: s390: interrupt: Fix single-stepping
 userspace-emulated instructions
Content-Language: en-US
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>
References: <20230721120046.2262291-1-iii@linux.ibm.com>
 <20230721120046.2262291-5-iii@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230721120046.2262291-5-iii@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +		rc = -ENOIOCTLCMD;
> +		break;
>   	}
> -	return -ENOIOCTLCMD;
> +

This really needs a comment. :)

> +	if (!rc)
> +		vcpu->guest_debug &= ~KVM_GUESTDBG_EXIT_PENDING;
> +
> +	return rc;
>   }
>   
>   static int kvm_s390_handle_pv_vcpu_dump(struct kvm_vcpu *vcpu,

-- 
Cheers,

David / dhildenb

