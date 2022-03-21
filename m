Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AA54E24E5
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 12:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346595AbiCULDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 07:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346603AbiCULDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 07:03:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEF3214B84C
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 04:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647860505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=71QPtwQWP7irJw6pdvQh6v8H9j0P/xaK2PjPht9nnok=;
        b=Wqk5Q8dmbqO+Y1Gp8hdYRVet3z6OuPHfaCgY2+DZYgw2jw+dZmlDCTBCDXo79ukOkR46O7
        lBoM1AQojsmqIbmnX80zSNRiaKbfoanVE0pFxPsvE1mZYGgjpouxsfqUVOSx2KqsVrkwdI
        pLansUabDCDZhSAQiEDJBdaFbD/c438=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-Dl8Sg7KzNLSXn3RYOweMlA-1; Mon, 21 Mar 2022 07:01:43 -0400
X-MC-Unique: Dl8Sg7KzNLSXn3RYOweMlA-1
Received: by mail-ed1-f69.google.com with SMTP id w8-20020a50d788000000b00418e6810364so8331816edi.13
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 04:01:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=71QPtwQWP7irJw6pdvQh6v8H9j0P/xaK2PjPht9nnok=;
        b=A4th/5HeOwj4sMS0Lt0OpKeQk76RLYDwV87XjmT7xol3RzgV2p0/1zsr03YBhSVudD
         8SrBTrP5bwpnGrLfBY+VbEGN6kEYZTP8ghVwH+ZIRFCEnQPjqVogOy12xZYjds4fAZyu
         zHjMhSgvrD3/4AbfoEOMs1tDNLvrMOpoP9IV6Gu58/GdVkhHXDD6W0Z5zxqQLRPjhW1y
         95qnQyvRj8joKM3ojqoMSo8mWPEBVXT8AWeYuqVkF7z3rbsmbc5E5ixRomdL9gNC+Kow
         IWTrGSVqcpkddMnqe3yaqOqFiuHb9TwPK/dLJ1sFuvfMwAq9SUfF8KJi6GciIr2/IF7I
         FBvQ==
X-Gm-Message-State: AOAM532JlKhiV0tGv87RNL+oLcqU1aOImfv9/Hictvr9tkyklSahbxuq
        m3F1VfK8H/XnYz5QUH0KZHm3PxKD+zc65OoBkj5uHxOF5R3UEJwpWoCBIDJqn8b9dUQCO+W+OEv
        7c0TQuxrQOzbv
X-Received: by 2002:a17:907:7254:b0:6db:ad8f:27b4 with SMTP id ds20-20020a170907725400b006dbad8f27b4mr20312101ejc.599.1647860502541;
        Mon, 21 Mar 2022 04:01:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw10B4UloyTBi1a7t4NLKKvwYaVeL4Lf9on50mGbJUjofJKCu/uM89wiMqWJDmBuZn+jijjIg==
X-Received: by 2002:a17:907:7254:b0:6db:ad8f:27b4 with SMTP id ds20-20020a170907725400b006dbad8f27b4mr20312076ejc.599.1647860502271;
        Mon, 21 Mar 2022 04:01:42 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id e28-20020a170906649c00b006df6dfeb557sm6869828ejm.49.2022.03.21.04.01.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 04:01:41 -0700 (PDT)
Message-ID: <33b6fb1d-b35c-faab-4737-01427c48d09d@redhat.com>
Date:   Mon, 21 Mar 2022 12:01:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [syzbot] WARNING in kvm_mmu_notifier_invalidate_range_start (2)
Content-Language: en-US
To:     syzbot <syzbot+6bde52d89cfdf9f61425@syzkaller.appspotmail.com>,
        david@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        maciej.szmigiero@oracle.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <000000000000b6df0f05dab7e92c@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <000000000000b6df0f05dab7e92c@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/21/22 11:25, syzbot wrote:
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a2d0a9700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d34fd9700000
> 
> The issue was bisected to:
> 
> commit ed922739c9199bf515a3e7fec3e319ce1edeef2a
> Author: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Date:   Mon Dec 6 19:54:28 2021 +0000
> 
>      KVM: Use interval tree to do fast hva lookup in memslots
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=142aa59d700000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=162aa59d700000
> console output: https://syzkaller.appspot.com/x/log.txt?x=122aa59d700000

It bisects here just because the patch introduces the warning; the issue 
is a mmu_notifier_invalidate_range_start with an empty range.  The 
offending system call

mremap(&(0x7f000000d000/0x2000)=nil, 0xfffffffffffffe74, 0x1000, 0x3, 
&(0x7f0000007000/0x1000)=nil)

really means old_len == 0 (it's page-aligned at the beginning of 
sys_mremap), and flags includes MREMAP_FIXED so it goes down to 
mremap_to and from there to move_page_tables.  No function on this path 
attempts to special case old_len == 0, the immediate fix would be

diff --git a/mm/mremap.c b/mm/mremap.c
index 002eec83e91e..0e175aef536e 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -486,6 +486,9 @@ unsigned long move_page_tables(struct vm_area_struct
  	pmd_t *old_pmd, *new_pmd;
  	pud_t *old_pud, *new_pud;

+	if (!len)
+		return 0;
+
  	old_end = old_addr + len;
  	flush_cache_range(vma, old_addr, old_end);

but there are several other ways to fix this elsewhere in the call chain:

- check for old_len == 0 somewhere in mremap_to

- skip the call in __mmu_notifier_invalidate_range_start and 
__mmu_notifier_invalidate_range_end, if people agree not to play 
whack-a-mole with the callers of mmu_notifier_invalidate_range_*.

- remove the warning in KVM

Thanks,

Paolo

