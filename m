Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92BE1129E3E
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 07:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfLXGvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 01:51:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26322 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726065AbfLXGvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 01:51:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577170265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=egW37jyR5y3OPQMHtqUo17115j/TrlvZWF1f6KXPyvo=;
        b=H4fJE31ZZ+71RM8Zoo/R34ThN8QQiNh4VW+o3DZviqwTQtdBtOj3QF30bVFszUKtbfMR8b
        Ox08TpNsawBh4BLt6PgJeiuiiUNeBuC1znuvEUjrOVEX9eVYB383HzjOIfO5ndSk4Uy/DN
        IulkTvEVFWyvTwSVsGuNGrcqjgjgG5E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-QuKkB-hxNOinjTfGhtrxTg-1; Tue, 24 Dec 2019 01:51:02 -0500
X-MC-Unique: QuKkB-hxNOinjTfGhtrxTg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05906800D53;
        Tue, 24 Dec 2019 06:51:01 +0000 (UTC)
Received: from [10.72.12.236] (ovpn-12-236.pek2.redhat.com [10.72.12.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFC5060C05;
        Tue, 24 Dec 2019 06:50:49 +0000 (UTC)
Subject: Re: [PATCH RESEND v2 15/17] KVM: selftests: Add dirty ring buffer
 test
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Dr David Alan Gilbert <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191221020445.60476-1-peterx@redhat.com>
 <20191221020445.60476-5-peterx@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b0dc3d30-7fa5-3896-6905-9b1cb51d8d6c@redhat.com>
Date:   Tue, 24 Dec 2019 14:50:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191221020445.60476-5-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/12/21 =E4=B8=8A=E5=8D=8810:04, Peter Xu wrote:
> Add the initial dirty ring buffer test.
>
> The current test implements the userspace dirty ring collection, by
> only reaping the dirty ring when the ring is full.
>
> So it's still running asynchronously like this:


I guess you meant "synchronously" here.

Thanks


>
>              vcpu                             main thread
>
>    1. vcpu dirties pages
>    2. vcpu gets dirty ring full
>       (userspace exit)
>
>                                         3. main thread waits until full
>                                            (so hardware buffers flushed=
)
>                                         4. main thread collects
>                                         5. main thread continues vcpu
>
>    6. vcpu continues, goes back to 1

