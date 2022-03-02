Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9CA4CAF77
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 21:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbiCBUPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 15:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiCBUPt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 15:15:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABBBCCD5E7
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 12:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646252104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hVPJAaQMiU/UUVUed6uCDuKTMuf559KPWfX+wu4fTKk=;
        b=i59GOofWv2vH6LZgMgu/o+2KW8Z1KSpOU+T0B9r0xZWMmKf+eO3biGEDmU5A8xLHvMnMe/
        Y/8NecYtdKXkM5ohmAvtzYWZyAHsUEZdTqUIVJtmXA7HW93ODFtpaiZE8ONxIofx0wou/n
        1uleomf6tyPH1gGzVqAbVMUzx7Vw7QA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-6tY7rmLoMT6FgdvP_49j3g-1; Wed, 02 Mar 2022 15:14:43 -0500
X-MC-Unique: 6tY7rmLoMT6FgdvP_49j3g-1
Received: by mail-wm1-f69.google.com with SMTP id az36-20020a05600c602400b003811b328ed5so825538wmb.4
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 12:14:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hVPJAaQMiU/UUVUed6uCDuKTMuf559KPWfX+wu4fTKk=;
        b=3GWRF2/dRv2YpbwPZ+gEsy2AisQ0rC+A1V9ffDHS5hjBvwy5fCJaz2TUdDchBWi01s
         KiTBWYZEuPcim3S/CxLNTnksly2PZPfospMy5VmetADjWa034yzbSF6o/ddr42ZvJ8cV
         orT+Lzcuj+AtrubGi9FXz7CQV+n/tv1et7ma5lQ9GpOVWyL3TUFPgFg2SP8pk+T7hM0x
         gZ7CZqfbYhnIeml3cyNURE9bjBJTRaon0HuTAw2iFBNd33mvhU0SICdrndygOuUMQU50
         j7l8HT5SILHM3EkGVneTixX5RPqcb0ujZ8zr2pGgctEnzFmteBXI830R325OlM7jfjPW
         edbw==
X-Gm-Message-State: AOAM5319KADX0TvAVVmRTm+jsGmLA3+72JzNyxkExHu69kS+/QGBKoc+
        htTeqgMvfE9rmiTu9JsR1o3GoPh0mBbDI33nr+1HaXDgUide2seE6sWwGcw7daPWdIIu6zu2apb
        K5ADGf58j6Tsm
X-Received: by 2002:adf:f201:0:b0:1ed:c254:c1a2 with SMTP id p1-20020adff201000000b001edc254c1a2mr23961966wro.106.1646252072323;
        Wed, 02 Mar 2022 12:14:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx1zw1C/i+VIT8MtTcEQD8KuDJhh889JvGLZ/u+ULO+AHhA9U6wjqYo14xKshNpXSJG0n0dqw==
X-Received: by 2002:adf:f201:0:b0:1ed:c254:c1a2 with SMTP id p1-20020adff201000000b001edc254c1a2mr23961947wro.106.1646252072075;
        Wed, 02 Mar 2022 12:14:32 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id g7-20020a5d5407000000b001e2628b6490sm17993wrv.17.2022.03.02.12.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 12:14:31 -0800 (PST)
Message-ID: <442859af-6454-b15e-b2ad-0fc7c4e22909@redhat.com>
Date:   Wed, 2 Mar 2022 21:14:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 22/28] KVM: x86/mmu: Zap defunct roots via asynchronous
 worker
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-23-seanjc@google.com>
 <b9270432-4ee8-be8e-8aa1-4b09992f82b8@redhat.com>
 <Yh+xA31FrfGoxXLB@google.com>
 <f4189f26-eff9-9fd0-40a1-69ac7759dedf@redhat.com>
 <Yh/GoUPxMRyFqFc5@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yh/GoUPxMRyFqFc5@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/2/22 20:33, Sean Christopherson wrote:
> What about that idea?  Put roots invalidated by "fast zap" on_another_  list?
> My very original idea of moving the roots to a separate list didn't work because
> the roots needed to be reachable by the mmu_notifier.  But we could just add
> another list_head (inside the unsync_child_bitmap union) and add the roots to
> _that_  list.

Perhaps the "separate list" idea could be extended to have a single 
worker for all kvm_tdp_mmu_put_root() work, and then indeed replace 
kvm_tdp_mmu_zap_invalidated_roots() with a flush of _that_ worker.  The 
disadvantage is a little less parallelism in zapping invalidated roots; 
but what is good for kvm_tdp_mmu_zap_invalidated_roots() is just as good 
for kvm_tdp_mmu_put_root(), I suppose.  If one wants separate work 
items, KVM could have its own workqueue, and then you flush that workqueue.

For now let's do it the simple but ugly way.  Keeping 
next_invalidated_root() does not make things worse than the status quo, 
and further work will be easier to review if it's kept separate from 
this already-complex work.

Paolo

