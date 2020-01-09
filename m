Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93627135E05
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 17:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387589AbgAIQRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 11:17:50 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36052 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730515AbgAIQRs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 11:17:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578586666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=utdlm/aKlY7xAQfEyR3w7Eafs4aRDid1gJnviBYktXw=;
        b=GA07ArlV88nReDVpVYvNrVS0AQixflrnWNK1HOba4yloPtQ2n3CD4XNgVxaohN/U8QfUcL
        bw2yY0M/tKw1QytwS/XqvPnRwsXLEqQQW/usAKCfKBax9ghhq3Nuo/n66+fDibnuUVmTA8
        P2Z93dlX8WNwOwsZuK8H0rQraeUFn1g=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-6rbjxreyMbifu6P2EAyoeA-1; Thu, 09 Jan 2020 11:17:45 -0500
X-MC-Unique: 6rbjxreyMbifu6P2EAyoeA-1
Received: by mail-qk1-f200.google.com with SMTP id d1so4476334qkk.15
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 08:17:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=utdlm/aKlY7xAQfEyR3w7Eafs4aRDid1gJnviBYktXw=;
        b=temOV5HPMrG7ezltUaAc3fBQqYbNmqXiyKA9LNMKj3+C1AD8yXJL8kujpaQjVogzF+
         lEl9s90Jf0J4lDH1Md9KlGZrjufU28hYvjIK3QjNb/Fd/t93/GKASPgYA415jghYWue+
         E4f6Nfcb4CeOWrBb6iIjsmAIgM1yGa1YzW3sWaNKsfZpI/i8yFpDiiso8h6zJF2v6eT2
         rr7DyZ/IP6eMA8sT8f8+1hCVM8Fl/4QbnZTu5ChT4yDtx+7xTLIIr+LVNZR+Hc/B//+f
         q6kxIQMrc42KddDhEgXgagmCXgKVThZ/8l+LI9VCyu3IYc3BmCMzQ5dPoqL/8mMMVLbh
         fiWA==
X-Gm-Message-State: APjAAAVv1vL9Pa3Rw4+gZwX8J2obQJ0Mgz7F388y9U+1cE41q5PvKIZR
        IkSq8SwAb71ZSD8BJMQw8110LbNILHO8AWAa/CmJH8hFQjpQ1HuFVD3CacQ+NN654y6+ouvraGQ
        4NJJD2uVxFY/g
X-Received: by 2002:ac8:544f:: with SMTP id d15mr8718687qtq.53.1578586665324;
        Thu, 09 Jan 2020 08:17:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqxOO77lSOX4HB1VsYJg95F5t9IBQf4gOicmO1+VK8TA5tARhYVtiz9nWGF7JPyZNSOqo/KKIw==
X-Received: by 2002:ac8:544f:: with SMTP id d15mr8718671qtq.53.1578586665141;
        Thu, 09 Jan 2020 08:17:45 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id m8sm3602484qtk.60.2020.01.09.08.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 08:17:43 -0800 (PST)
Date:   Thu, 9 Jan 2020 11:17:42 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v3 00/21] KVM: Dirty ring interface
Message-ID: <20200109161742.GC15671@xz-x1>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109105443-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200109105443-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 10:59:50AM -0500, Michael S. Tsirkin wrote:
> On Thu, Jan 09, 2020 at 09:57:08AM -0500, Peter Xu wrote:
> > Branch is here: https://github.com/xzpeter/linux/tree/kvm-dirty-ring
> > (based on kvm/queue)
> > 
> > Please refer to either the previous cover letters, or documentation
> > update in patch 12 for the big picture.
> 
> I would rather you pasted it here. There's no way to respond otherwise.

Sure, will do in the next post.

> 
> For something that's presumably an optimization, isn't there
> some kind of testing that can be done to show the benefits?
> What kind of gain was observed?

Since the interface seems to settle soon, maybe it's time to work on
the QEMU part so I can give some number.  It would be interesting to
know the curves between dirty logging and dirty ring even for some
small vms that have some workloads inside.

> 
> I know it's mostly relevant for huge VMs, but OTOH these
> probably use huge pages.

Yes huge VMs could benefit more, especially if the dirty rate is not
that high, I believe.  Though, could you elaborate on why huge pages
are special here?

Thanks,

-- 
Peter Xu

