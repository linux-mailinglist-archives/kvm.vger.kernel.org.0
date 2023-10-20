Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA617D13B8
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 18:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377823AbjJTQIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 12:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377813AbjJTQId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 12:08:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE65D7
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 09:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697818069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6sh2tTqqzt+fCS20R4EZXWMlcUrT2ew4eP3bmw4QvLU=;
        b=eLSnTAHrdaAU2o1tHCkS4LFIr5OUn4vgilhVfge+gjoeg5jSPEbszCAnrdUf9BMxGJ0n8/
        OA4souyETaQsjAP4iZKa2gK2EfJHJ9og8H2hWdhxKe/CVZszx93P3gErUbIy9tQx0mD4pn
        oFaSL2N/EUrFzJPFLcZum15KvPmI410=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-fMKHpESBMAGMrj_ARGJK_A-1; Fri, 20 Oct 2023 12:07:45 -0400
X-MC-Unique: fMKHpESBMAGMrj_ARGJK_A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B34A88B773;
        Fri, 20 Oct 2023 16:07:43 +0000 (UTC)
Received: from localhost (unknown [10.39.192.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACFEF111D798;
        Fri, 20 Oct 2023 16:07:41 +0000 (UTC)
Date:   Fri, 20 Oct 2023 09:07:40 -0700
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Juan Quintela <quintela@redhat.com>
Cc:     qemu-devel@nongnu.org, qemu-s390x@nongnu.org,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Juan Quintela <quintela@redhat.com>,
        Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?iso-8859-1?Q?Marc-Andr=E9?= Lureau 
        <marcandre.lureau@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>, qemu-arm@nongnu.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Thomas Huth <thuth@redhat.com>,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        qemu-ppc@nongnu.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Stefan Weil <sw@weilnetz.de>, Peter Xu <peterx@redhat.com>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Jeff Cody <codyprime@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Leonardo Bras <leobras@redhat.com>,
        Fabiano Rosas <farosas@suse.de>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Greg Kurz <groug@kaod.org>, qemu-block@nongnu.org
Subject: Re: [PULL 00/17] Migration 20231020 patches
Message-ID: <20231020160740.GA472217@fedora>
References: <20231020065751.26047-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dQl1U8CNCS9+/GUj"
Content-Disposition: inline
In-Reply-To: <20231020065751.26047-1-quintela@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--dQl1U8CNCS9+/GUj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/8.2 for any user-visible changes.

--dQl1U8CNCS9+/GUj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUypcwACgkQnKSrs4Gr
c8gs3Af/d/J1Qw1a6oSy8Cx1C9N0Ia4e908KPVp3OfXPjwqroYXoyb3RWPdqxY7B
y3UUFgEr5C69ZOEbhb04N5tPc7QVvwcpmviB4DmcAtBycBl3sxCXWaejzvOmfm1w
m/Q5NUJe0EoKX6sSqYxx/99cZA998qotK+jsZHtPnvrB03MV3k03lUl3uPBEs5un
9G1GRWl/HFYFg11fdxJt9IozCzb5C+cirkU5SmEPHWGd7Ee6J/N7KPhSo0EqcKws
LaMox+Ic/cJClzZJ1yXyKHKFtqcognYx9+ViktOVCVIRE0IYQvUgD0nV0qIAV9r6
NKL/P6v8LUifcCk3eAoC8UarO0NVeg==
=CToo
-----END PGP SIGNATURE-----

--dQl1U8CNCS9+/GUj--

