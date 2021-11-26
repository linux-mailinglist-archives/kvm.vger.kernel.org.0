Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F46445EDCC
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 13:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377188AbhKZMYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 07:24:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33477 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244365AbhKZMWQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 07:22:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637929143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5WkxyGGreyu/PhUR7qQXkxF/UT6auliTNGcHoU1VQhg=;
        b=DzsOxG/xT+QU9Z+ao8+HS32BUArz4FUIvBkUAewEIzAqs1e2aWn6QBFotRSJlB6foOoFv1
        bVfN5tNRJ1sDR1tXjsPekTbDk1sdNUkZ9CBVim4gvq6QqNy3O+9mJBXoYnstCrqoYn195Y
        0YFfhUReYWp4eUA3Jy5+raW9K6WmF80=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-ldgeDwhmMwuPNxl5bYzbCQ-1; Fri, 26 Nov 2021 07:19:02 -0500
X-MC-Unique: ldgeDwhmMwuPNxl5bYzbCQ-1
Received: by mail-pl1-f198.google.com with SMTP id l14-20020a170903120e00b00143cc292bc3so3894729plh.1
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 04:19:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5WkxyGGreyu/PhUR7qQXkxF/UT6auliTNGcHoU1VQhg=;
        b=2pi09ZbY/Hd4chBwGi9UhBPAWqO/Vu2nsZ0QBOqGifk1hUV3ppPxMSDtkF0cstM5FA
         XvKPwRS/xGNke5mXyR/yQpTxkiCqdAuH2VUPapGsSpwwSjvLo5OK4YrNkRFRlTAsNK+D
         xpZ9T2LDeYrnq7ersFazKlJCcWR4G3JUZNeWE1H10Lt5CmyirB0wF0OgnAC1DiekQsoT
         RVm/Q0WZBzDDBwqQQQnhtNE0OKFnhMVZsXS14s8wk6NYUijEAoBJHmh0VygAhhEA9U+u
         LbSq2EAitSKtivj0GxnNnghDe8H4Y/McCPld0YMQkmSsK0tRoMr4gxwZOMWsSYODhJlR
         yz6Q==
X-Gm-Message-State: AOAM5333dZhHXpZo69WHxanQOz8erXKsRnFVgncgu/PF8R3fJDJ7K16w
        7st/csS6hB+/dAqXYXOjJ4oSGY37pDTLZNPUIYXtXZsjAOihsvQZMIkMW+OR6mZPQKkbVEjp0e6
        31NtTKT2YnFdI
X-Received: by 2002:a17:902:c105:b0:142:2441:aa24 with SMTP id 5-20020a170902c10500b001422441aa24mr37849620pli.44.1637929141341;
        Fri, 26 Nov 2021 04:19:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygyg8mjLb5Jne8Ms2ec5RvJHc+ZWiG+P2/JE2sGi2DVTgK0PGvwjB7mtbk7RxbyMZeZgJVLw==
X-Received: by 2002:a17:902:c105:b0:142:2441:aa24 with SMTP id 5-20020a170902c10500b001422441aa24mr37849588pli.44.1637929141099;
        Fri, 26 Nov 2021 04:19:01 -0800 (PST)
Received: from xz-m1.local ([94.177.118.150])
        by smtp.gmail.com with ESMTPSA id t4sm7324062pfq.163.2021.11.26.04.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 04:19:00 -0800 (PST)
Date:   Fri, 26 Nov 2021 20:18:53 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [RFC PATCH 02/15] KVM: x86/mmu: Rename __rmap_write_protect to
 rmap_write_protect
Message-ID: <YaDQrX/tt7ZD5Rm8@xz-m1.local>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211119235759.1304274-3-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 11:57:46PM +0000, David Matlack wrote:
> Now that rmap_write_protect has been renamed, there is no need for the
> double underscores in front of __rmap_write_protect.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

