Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7CA210CC02
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 16:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfK1Ppi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 10:45:38 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25287 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726583AbfK1Ppi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 10:45:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574955937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xGsdSO+ydrVZSxWYC3w/X6LXKszicUiIA0Toh6QzZtQ=;
        b=UaTOd3WGUm3+MMF/KUBBER8Oy5KQHw4SHeamaO4xhuif/7PHSSnNYDgHQ4u1AmA93GTb/Y
        /WMjCDXrOcJhthshK215PebzCctSjYqpfx21d00q0PDdsXUjL41R+AeGI/qmxDco3A9W3k
        seby3a29WKDVCGIRHCV63HcShP2jpNo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-EdkpEs06Ou6r7LN4QsYqQQ-1; Thu, 28 Nov 2019 10:45:33 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CB46106B329;
        Thu, 28 Nov 2019 15:45:32 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ABCCD608C2;
        Thu, 28 Nov 2019 15:45:27 +0000 (UTC)
Date:   Thu, 28 Nov 2019 16:45:25 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Bill Wendling <morbo@google.com>, kvm-ppc@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Laurent Vivier <lvivier@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2] Switch the order of the parameters in
 report() and report_xfail()
Message-ID: <20191128154525.xnrzzxtxacldrh7n@kamzik.brq.redhat.com>
References: <20191128071453.15114-1-thuth@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191128071453.15114-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: EdkpEs06Ou6r7LN4QsYqQQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 28, 2019 at 08:14:53AM +0100, Thomas Huth wrote:
> Commit c09c54c66b1df ("lib: use an argument which doesn't require
> default argument promotion") fixed a warning that occurs with Clang,
> but introduced a regression: If the "pass" parameter is a value
> which has only set the condition bits in the upper 32 bits of a
> 64 bit value, the condition is now false since the value is truncated
> to "unsigned int" so that the upper bits are simply discarded.
>=20
> We fixed it by reverting the commit, but that of course also means
> trouble with Clang again. We can not use "bool" if it is the last
> parameter before the variable argument list. The proper fix is to
> swap the parameters around and make the format string the last
> parameter.
>=20
> This patch (except the changes in lib/libcflat.h and lib/report.c
> and some rebase conflicts along the way) has basically been created
> with following coccinelle script (with some additional manual tweaking
> of long and disabled lines afterwards):
>=20
> @@
> expression fmt;
> expression pass;
> expression list args;
> @@
>  report(
> -fmt, pass
> +pass, fmt
>  , args);
>=20
> @@
> expression fmt;
> expression pass;
> expression list args;
> @@
>  report_xfail(
> -fmt, xfail, pass
> +xfail, pass, fmt
>  , args);
>=20
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  v2: Rebase the patch to the current master branch
>

Tested on arm and arm64.

Tested-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

