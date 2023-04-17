Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37CD86E4630
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 13:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjDQLRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 07:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjDQLR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 07:17:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DC25242
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 04:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681730081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5KNRdeLRU2Xq/n1iDZzMtTXMvfraDKy7YfY/QU65aIc=;
        b=i3oFxczaEt479I0iFXaRhrqLSx9P6FifoKisSNQvp7e9tktK5cHxJxAFqtr3/GP3+qQL9I
        nFNrBUPeyJNPD5WLlgYOR+rD9soVZlgW5jRZCfGZG+xYH4q8JIoahT5ZvWoP57opaZ5sBw
        6jIV08hpzQ46euOkDOabHH0mEPAqZTI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-Vmwz5GLyMSq-aZoz9pyE1g-1; Mon, 17 Apr 2023 07:14:40 -0400
X-MC-Unique: Vmwz5GLyMSq-aZoz9pyE1g-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f080f534acso8156385e9.0
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 04:14:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681730079; x=1684322079;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5KNRdeLRU2Xq/n1iDZzMtTXMvfraDKy7YfY/QU65aIc=;
        b=AQF87tNCkmQOY5ZPO8O7mmA5wPu9l+nAM2f+ENiGPIhlCQ1UXq8Fp9Zo/Qn2xRyBct
         pdaMmJCKQk9IpVKRK8M35tqw1iDGfiEBuBinR71Tvz/JJQCmgjniOgiRVyb6hDxsVJjH
         l76j/SZ/TqT6fwGiIqrXtJguw0Arsy4sDimXwq757FL+5m9qc+QNKRFGQ2RsDSzv8IT5
         ldrstcQGS9nscr8qH/uewiUq4YL1VVccvix304NWC/6+n0V/0C50LmHnvDYNZI/cOkyp
         MPzP6Fj1PfwQ3M3Rv2oTlIGBc4XM7bfYmtobqT4nD1O15rOqK6oiWn4c9MJa/1D+KlG2
         KZ6g==
X-Gm-Message-State: AAQBX9fQICmLXE+4zZ/s7I7G0I/cufsR6MESI0x33rbye3VNcEP87V6g
        RAQwOb/MyhDYWgTTXtBk8npP6dm/lydMV5PejEj3jUg1ZIjV84me8HCNKLdMTi14Q9K4Au+Lgqr
        N7uowGACCuyrP
X-Received: by 2002:a5d:650c:0:b0:2f8:3225:2bc2 with SMTP id x12-20020a5d650c000000b002f832252bc2mr4681562wru.41.1681730079150;
        Mon, 17 Apr 2023 04:14:39 -0700 (PDT)
X-Google-Smtp-Source: AKy350bNt0CQlgSAneNNoqT/xp81/MyHZrBQz3dDdnffEdIUnbPzTF+43gFytbOZ+e3kttt+3w0ALw==
X-Received: by 2002:a5d:650c:0:b0:2f8:3225:2bc2 with SMTP id x12-20020a5d650c000000b002f832252bc2mr4681519wru.41.1681730078827;
        Mon, 17 Apr 2023 04:14:38 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:fc00:db07:68a9:6af5:ecdf? (p200300cbc700fc00db0768a96af5ecdf.dip0.t-ipconnect.de. [2003:cb:c700:fc00:db07:68a9:6af5:ecdf])
        by smtp.gmail.com with ESMTPSA id v3-20020adfe4c3000000b002f459afc809sm10282660wrm.72.2023.04.17.04.14.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 04:14:38 -0700 (PDT)
Message-ID: <eb624430-6fb5-0349-0798-3f71c39e8768@redhat.com>
Date:   Mon, 17 Apr 2023 13:14:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v3 6/7] mm/gup: remove vmas parameter from
 pin_user_pages()
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        linux-media@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org
References: <cover.1681558407.git.lstoakes@gmail.com>
 <fa5487e54dfae725c84dfd7297b06567340165bd.1681558407.git.lstoakes@gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <fa5487e54dfae725c84dfd7297b06567340165bd.1681558407.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15.04.23 14:09, Lorenzo Stoakes wrote:
> After the introduction of FOLL_SAME_FILE we no longer require vmas for any
> invocation of pin_user_pages(), so eliminate this parameter from the
> function and all callers.
> 
> This clears the way to removing the vmas parameter from GUP altogether.
> 
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---

Ideally, we'd avoid FOLL_SAME_FILE as well

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

