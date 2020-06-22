Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E5B204199
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 22:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730927AbgFVUL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 16:11:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60812 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730896AbgFVULX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 16:11:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592856682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mTc3nTuv3+E95YWblrZ4womgAmwm01Da22NV/Nv8VAA=;
        b=DC+4koDzFcJe0nNOLUQ1Q5FPi0tsMeX0a/azwFR4bJV8STGtRi0h3Z6pU+UbGSIAYEe/n4
        tq2VB4N8OFsdZ+7Yre/iUESvTdphcjXIE9WPHju4dVm2L7a8AT3JC5VwXghTXZ63MpyX65
        69s62s450kjYsJHZybiJ6wsD77aDxVQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-plwrIt9uN_G2waASGBkpag-1; Mon, 22 Jun 2020 16:11:20 -0400
X-MC-Unique: plwrIt9uN_G2waASGBkpag-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF0D0804004;
        Mon, 22 Jun 2020 20:11:18 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CA1E619D61;
        Mon, 22 Jun 2020 20:11:16 +0000 (UTC)
Date:   Mon, 22 Jun 2020 22:11:13 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>, Haibo Xu <haibo.xu@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: Re: [PATCH v2] target/arm: Check supported KVM features globally
 (not per vCPU)
Message-ID: <20200622201113.o7uqsgiuyyvfgmgm@kamzik.brq.redhat.com>
References: <20200619095542.2095-1-philmd@redhat.com>
 <20200619114123.7nhuehm76iwhsw5i@kamzik.brq.redhat.com>
 <CAFEAcA-3keThbaWccv+Rzh4dmnLquSwXMyEOmbMMHgQHM=c-8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA-3keThbaWccv+Rzh4dmnLquSwXMyEOmbMMHgQHM=c-8Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 22, 2020 at 08:57:51PM +0100, Peter Maydell wrote:
> On Fri, 19 Jun 2020 at 12:41, Andrew Jones <drjones@redhat.com> wrote:
> > Can you also post the attached patch with this one (a two patch series)?
> 
> This would be easier to review if you'd just posted it as
> a patch with a Based-on: and a note that it needed to be

OK, will do.

> applied after the bugfix patch. Anyway:
> 
> +    /* Enabling and disabling kvm-no-adjvtime should always work. */
>      assert_has_feature_disabled(qts, "host", "kvm-no-adjvtime");
> +    assert_set_feature(qts, "host", "kvm-no-adjvtime", true);
> +    assert_set_feature(qts, "host", "kvm-no-adjvtime", false);
> 
>      if (g_str_equal(qtest_get_arch(), "aarch64")) {
>          bool kvm_supports_sve;
> @@ -475,7 +497,11 @@ static void
> test_query_cpu_model_expansion_kvm(const void *data)
>          char *error;
> 
>          assert_has_feature_enabled(qts, "host", "aarch64");
> +
> +        /* Enabling and disabling pmu should always work. */
>          assert_has_feature_enabled(qts, "host", "pmu");
> +        assert_set_feature(qts, "host", "pmu", true);
> +        assert_set_feature(qts, "host", "pmu", false);
> 
> It seems a bit odd that we do the same "set true, then
> set false" sequence whether the feature is enabled or not.
> Shouldn't the second one be "set false, then set true" ?

That would be better. Will do.

Thanks,
drew

