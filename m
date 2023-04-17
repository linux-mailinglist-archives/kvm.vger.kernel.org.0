Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48DF6E4DAA
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 17:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbjDQPux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 11:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjDQPul (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 11:50:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B624CC0D
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 08:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681746536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7wxMSQuAkXI9cFCvxCKTnw1/xApBRZipM9gJxQ7MGaY=;
        b=BiprF9jel+C15KTwJ6xS9cfJQr2X5HF5cc/fv1CtyeuE5/weRXOHEfTqXS+FnwVAUOSGaE
        dm5Hiq9+fBTWHZq5SzYIqH5qqdPpohJ3uYMlx5VZc0g8mzyTVRCgURTmbgDl6/9ZPu4Vgk
        88Eb7DZt3fIUArKliFoakxuPQqmtZOQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-Dikz1v0mPRGRa34qqb4_0Q-1; Mon, 17 Apr 2023 11:48:53 -0400
X-MC-Unique: Dikz1v0mPRGRa34qqb4_0Q-1
Received: by mail-wm1-f72.google.com with SMTP id p34-20020a05600c1da200b003f175d06dfcso596648wms.2
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 08:48:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681746532; x=1684338532;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7wxMSQuAkXI9cFCvxCKTnw1/xApBRZipM9gJxQ7MGaY=;
        b=SSKIrsrRn03g0gTuP5Ko1+dL0rfM0v3NQ8bQ+qOzeMgInEkTWmjxOQCCnwLhUxMNEA
         S8IMKX4k2WtwCtgpAtLog9m9L5UNSjOPQfxXejHfNXzhcQCPtJuxxWgfT7rihkCoIsBw
         Ay3yv78DKD1w3MrpBkVWOMgFs8X/qanwhVqhvRhCDYxsc4nkGWU2h6pLUrItWuAuxnUC
         YLn8ublAOKg+C2Ns8c5jkrvJUz3C3UCvaxUCJlXXGbhLyBXBWEpcuVHlEIJe3AEmBiaL
         N2tdO/FTP/7tO22yPHex+Z2H/ei8qmudXVA8cQQTUPmN9gc+wwSRPzTTIb3v0pOfbXHD
         5VJw==
X-Gm-Message-State: AAQBX9cfQ3nq/KBGiIUvDu4A5KRWR1yazJw8CO81CinP8rrXksld7O+4
        ARuY2x0SSTDFqxNhi836ed6R7AHdpS1IbM0jjLlrv0swtUAEVdLJzJIFHIBq+lYEvuHmO/LxMfh
        IsE70ys1/Sa1G
X-Received: by 2002:a7b:ce91:0:b0:3ed:e4ac:d532 with SMTP id q17-20020a7bce91000000b003ede4acd532mr12095008wmj.36.1681746532746;
        Mon, 17 Apr 2023 08:48:52 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z/kkuZ9k8vVAAV0sPAD+AAjEjwEWGBQNBxSnsCQt10m6JGA4msRSWOX0jSx9DH/y5hdc5Shw==
X-Received: by 2002:a7b:ce91:0:b0:3ed:e4ac:d532 with SMTP id q17-20020a7bce91000000b003ede4acd532mr12094976wmj.36.1681746532424;
        Mon, 17 Apr 2023 08:48:52 -0700 (PDT)
Received: from [192.168.3.108] (p5b0c6d51.dip0.t-ipconnect.de. [91.12.109.81])
        by smtp.gmail.com with ESMTPSA id s16-20020a05600c319000b003f17122587bsm5278743wmp.36.2023.04.17.08.48.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 08:48:51 -0700 (PDT)
Message-ID: <658018f9-581c-7786-795a-85227c712be0@redhat.com>
Date:   Mon, 17 Apr 2023 17:48:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        tabba@google.com, Michael Roth <michael.roth@amd.com>,
        wei.w.wang@intel.com, Mike Rapoport <rppt@kernel.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
 <ZD1oevE8iHsi66T2@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <ZD1oevE8iHsi66T2@google.com>
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

On 17.04.23 17:40, Sean Christopherson wrote:
> What do y'all think about renaming "restrictedmem" to "guardedmem"?

Yeay, let's add more confusion :D

If we're at renaming, I'd appreciate if we could find a terminology that 
does look/sound less horrible.

> 
> I want to start referring to the code/patches by its syscall/implementation name
> instead of "UPM", as "UPM" is (a) very KVM centric, (b) refers to the broader effort
> and not just the non-KVM code, and (c) will likely be confusing for future reviewers
> since there's nothing in the code that mentions "UPM" in any way.
> 
> But typing out restrictedmem is quite tedious, and git grep shows that "rmem" is
> already used to refer to "reserved memory".
> 
> Renaming the syscall to "guardedmem"...

restrictedmem, guardedmem, ... all fairly "suboptimal" if you'd ask me ...

-- 
Thanks,

David / dhildenb

