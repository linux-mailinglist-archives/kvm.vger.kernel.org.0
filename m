Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920703EE6F5
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 09:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbhHQHGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 03:06:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58812 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233688AbhHQHGk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Aug 2021 03:06:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629183967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ACHPJbIdKDUhS/odG6yGvHlRzyASudkbg/mNYu8Y77o=;
        b=Ei0IYgQzQ4ub3oKkJY304W+eG+wmKbzo93ss4FV2wj2MDOv/zkJr5hcE+Uu/3fSd60bpoF
        k57nTDtot2vR5BC5/HipDs+p6e3URmA0RZjjrG47QCo60IKtyb3OwG53AGoXu/irrgEhWI
        sNta5yP2m7m3M1HgqhH2Ab1LW2LkPsc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-b-b2cSWuOsOeOsKVG2OiQw-1; Tue, 17 Aug 2021 03:06:05 -0400
X-MC-Unique: b-b2cSWuOsOeOsKVG2OiQw-1
Received: by mail-ed1-f71.google.com with SMTP id e3-20020a50ec830000b02903be5be2fc73so10066054edr.16
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 00:06:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ACHPJbIdKDUhS/odG6yGvHlRzyASudkbg/mNYu8Y77o=;
        b=gNixiCk0DHkZL6j2tk2eQeyDycCFnhcI97iIDgavaYB2j1W0Ey9yNFuXNhv5U9cA2J
         ewa9B0N5D+Fupgkcp+1Njhr5ETf0X5uUCe5UFzxASGqW1s6VDM8Ry3u+srDzrVaV7Cal
         d9jnRHtFNQJS1mUwCY/Zg9CRVVX4oljMKQfh6Sq5ctV+hKtUi+vpivcbWSYXTWcU4axP
         v8/a1caNIjw++hHCbE9uznmRORrrCS8rvZm3CGlTkzHqpIHTQgz3oRZsfAEQ7bkOkyjO
         40OpFQFZoGuULvoBYUmSoqLjXy9zQTGsz0LcqXjwIxAA5KTHtW+vzmWwolkC94cu8Mci
         doZw==
X-Gm-Message-State: AOAM532w4QAO2AwtFk/DyUq94uzTpYuzhMq05CX2MAqCmvEX17i/5rIg
        JAUrk728AEkeGLJu3Fwte+25sCEfrwrB8EOGHWZCJ+YA9jdkTIkcN/K9bGVfJumAiK4ob/qAAij
        CtCaXHUxYsPSi
X-Received: by 2002:a17:907:7883:: with SMTP id ku3mr2397737ejc.453.1629183964498;
        Tue, 17 Aug 2021 00:06:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWnXeTRbnJ+IA8um/1WaCevePcTlg5rkoMqIos60WP0jOTxWS8o35Ua2QT0cMewf32pgMF2A==
X-Received: by 2002:a17:907:7883:: with SMTP id ku3mr2397720ejc.453.1629183964381;
        Tue, 17 Aug 2021 00:06:04 -0700 (PDT)
Received: from redhat.com ([2.55.150.133])
        by smtp.gmail.com with ESMTPSA id h10sm564625edb.74.2021.08.17.00.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 00:06:03 -0700 (PDT)
Date:   Tue, 17 Aug 2021 03:05:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, qemu-devel@nongnu.org,
        pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
Message-ID: <20210817024924-mutt-send-email-mst@kernel.org>
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 16, 2021 at 04:53:17PM -0700, Steve Rutherford wrote:
> Separately, I'm a little weary of leaving the migration helper mapped
> into the shared address space as writable. Since the migration threads
> will be executing guest-owned code, the guest could use these threads
> to do whatever it pleases (including getting free cycles). The
> migration helper's code needs to be trusted by both the host and the
> guest. Making it non-writable, sourced by the host, and attested by
> the hardware would mitigate these concerns.

Well it's an ABI to maintain against *both* guest and host then.

And a separate attestation isn't making things easier to manage.

I feel guest risks much more than the hypervisor here,
the hypervisor at worst is giving out free cycles and that can
be mitigated, so it makes sense to have guest be in control.

How about we source it from guest but write-protect it on the
hypervisor side? It could include a signature that hypervisor could
verify, which would be more flexible than hardware attestation.

-- 
MST

