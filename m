Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15054D95E9
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 09:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345755AbiCOIJg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 04:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237121AbiCOIJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 04:09:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B7CC112622
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 01:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647331699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vBxdygrDGnIdQovqZjnOBUiE0fFV5TKmJtEmU95vBEM=;
        b=UaDEf5iXYXl2xgIyf2JFZVzihSrcOyXxLViKJctWbox8rw/kB2cjRDq6qpK+msVOeodC10
        c1afdy+JDq7uv2BBMleLzKvu2Ay1pc3B/TAuFjh7KXJitnWcAGmLGX/nLMIIsaTuEIENUD
        SAX1GDe0Cf3zw0HaK+QOmiwpi/Qqvfw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-VyHrVFwyPimbYs9WNtAHzA-1; Tue, 15 Mar 2022 04:08:18 -0400
X-MC-Unique: VyHrVFwyPimbYs9WNtAHzA-1
Received: by mail-wr1-f70.google.com with SMTP id e6-20020a5d4e86000000b001f045d4a962so5012676wru.21
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 01:08:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vBxdygrDGnIdQovqZjnOBUiE0fFV5TKmJtEmU95vBEM=;
        b=uDnpKKrJ3Ny5/i5uHL+ZBcB6YSNuSdaPzRZVO4OmL6bJ18w4GzBaQckkzYTkXDwdZS
         /TOPytxCDGhI1FFRjLrc0r4oP46jWmRaLBDdJGUhNnJQdxTxEuz+ot8bn79llPgAatpr
         G2Vx0lo5rDPvvWJ+SKmx5gVABMjJ307IXu7HY+kbMiftAePpBLn3jceSzAugDJ4VrSvI
         WIwowERp+bqR+7d0I7uJ5Ujgr1xUCSoqK0zbqsMJaVXYeCCs4rOgKDBoFCooXWZ3OdHe
         igrbp30KoKi2npStmfadVrP4sUqndRYdu8TkKc5jXa45uQQ0JVb2ATVKtPoCbQWVKbKj
         8oFw==
X-Gm-Message-State: AOAM532l8RQFcLj5f8+axnAgxePVetJ9Rjh7v5U0UgNlJa9ip6mu+eny
        d8rpc3o6txV6eUkwWsQ4RFEwBcC8Z20j+Jy+TqW2c1dYUeSFGIYW5Z6fFr2TYQfGzN5toodV6RT
        PYlSaH3QtWPxc
X-Received: by 2002:adf:dc86:0:b0:1f0:250a:265 with SMTP id r6-20020adfdc86000000b001f0250a0265mr19331369wrj.85.1647331697395;
        Tue, 15 Mar 2022 01:08:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycN8k8k30GqvbuzPk3qK11Jv29vfX/EQcOg+NXt/NpyhDzihkbEOBexiZimm3rtZNSjRc4pA==
X-Received: by 2002:adf:dc86:0:b0:1f0:250a:265 with SMTP id r6-20020adfdc86000000b001f0250a0265mr19331361wrj.85.1647331697232;
        Tue, 15 Mar 2022 01:08:17 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id f7-20020a0560001a8700b00203c23e55e0sm3467969wry.78.2022.03.15.01.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 01:08:16 -0700 (PDT)
Date:   Tue, 15 Mar 2022 09:08:14 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [RFC PATCH 000/105] KVM: selftests: Overhaul APIs, purge VCPU_ID
Message-ID: <20220315080814.sqfhamts5tekhxlj@gator>
References: <20220311055056.57265-1-seanjc@google.com>
 <20220314110653.a46vy5hqegt75wpb@gator>
 <Yi+B5bZ1LpaNCUJT@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yi+B5bZ1LpaNCUJT@google.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 14, 2022 at 05:56:53PM +0000, Oliver Upton wrote:
> 
> I think it may make more sense to only define optional functions as
> weak and let the compiler do the screaming for the required ones. Only
> discovering that functions are missing at runtime could be annoying if
> you're cross-compiling and running on a separate host with a different
> architecture.
>

Ah, indeed, no reason to push the lack of required arch functions to
runtime detection, compile time is much better. And, in those cases,
the _arch_ naming will also provide a nice hint that one must implement
it in arch specific code.

Thanks,
drew

