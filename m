Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DEE484EE1
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 08:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238223AbiAEHvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 02:51:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229880AbiAEHvj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 02:51:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641369098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E1ei5donPGydhH9z+6TlEvKufCFHVEI7eu7MdCk1hp8=;
        b=X35D5IDQA9JKuZOudCmWB9TZplkRLVD+oPd49/nAwW85qxxlIkght5ykBkeRDxK+WwzTEA
        xdrdzLddHk6qhEUtWhJmKdpNh1u8lxJHmiE8LvNLg+ReqFAiXKL8MnScNNJGbNq8LF3M3d
        yy5bJtzY5xjn0hbVyemUKMzfGy+5Hsg=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-pV4-BSeQP5KQXckob-4yoA-1; Wed, 05 Jan 2022 02:51:37 -0500
X-MC-Unique: pV4-BSeQP5KQXckob-4yoA-1
Received: by mail-pj1-f70.google.com with SMTP id p1-20020a17090a680100b001b1ea621b81so25766808pjj.2
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 23:51:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E1ei5donPGydhH9z+6TlEvKufCFHVEI7eu7MdCk1hp8=;
        b=BdOzJMQNtw+dlYE+paZijYTnKJCffoG9edH6ec5jUHOE3HY/PDDL0Ksnj3bRlpQ+bu
         6+QJwWG67YkbYzLweCme9b0Zqz9hm+uhIp7gxo9WKIx4yyJB8BXop5kIiCpM0ePXLayP
         VvQRHeJ8if34XT+l7luBEbBD27ThoaM3n969Out0q9rFz9RfkdIhSwz9+aaT76UJTq07
         91OnOwryiSgZa7K7ki3Bp/UCbxtIlT5bfzoOKCApUaIbPJGbgyHvE2xt/Uxueb+bixQ8
         e23R6zzkcxOhCZ/4cRhVCVMkZCw5k+2UdlwXKW2O6zJu6Rad3leKcrkcxvBoNlm1EfLk
         N3Mw==
X-Gm-Message-State: AOAM533RHSbiMueHwQ8niwZnmgtXx1h1/h2D4QyOo7IFj+KXV9mSjB9C
        bbKRLdDDblHPzB60n2ead25WU2FAT/yUkjvAhWp5zmB7Y63td+YB37xx+v2JFTX3HrvTxS7daLK
        JDljt+yJw4MRN
X-Received: by 2002:a17:902:ed54:b0:149:7c61:ad33 with SMTP id y20-20020a170902ed5400b001497c61ad33mr41424071plb.22.1641369096589;
        Tue, 04 Jan 2022 23:51:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzIlHrdiZBdI/Wy0Dzk8JokqQq3uBZo60xN8snTilp1wQNHAW3UvGLv5CBQPF2A2G3ofJBn1w==
X-Received: by 2002:a17:902:ed54:b0:149:7c61:ad33 with SMTP id y20-20020a170902ed5400b001497c61ad33mr41424056plb.22.1641369096380;
        Tue, 04 Jan 2022 23:51:36 -0800 (PST)
Received: from xz-m1.local ([191.101.132.50])
        by smtp.gmail.com with ESMTPSA id x19sm972132pgi.19.2022.01.04.23.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 23:51:35 -0800 (PST)
Date:   Wed, 5 Jan 2022 15:51:28 +0800
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
        Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 07/13] KVM: x86/mmu: Derive page role from parent
Message-ID: <YdVOAJGiSiu5T9S9@xz-m1.local>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-8-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-8-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021 at 10:59:12PM +0000, David Matlack wrote:
> Derive the page role from the parent shadow page, since the only thing
> that changes is the level. This is in preparation for eagerly splitting
> large pages during VM-ioctls which does not have access to the vCPU
> MMU context.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

