Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40636F7F26
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 10:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjEEIdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 04:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbjEEIc7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 04:32:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E25A18DD8
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 01:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683275480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=YNt/vTXhUWiJM7nukOOb6d/wZea7+zZe5F9nM074ahuxLk0BA7TXi7UvbZRW6xxg3WFdls
        E79b0l78g5sVjPud0EygryclRJPra8snUZrHQBm4qDCZt283ZThWkHHIdxrelMLwDhEX+5
        SpKYXFjNrmpSpnpHYBTG6jJtNoPDRJg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-mGseqgjQMcGN3LIBVwhAEw-1; Fri, 05 May 2023 04:31:19 -0400
X-MC-Unique: mGseqgjQMcGN3LIBVwhAEw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-965c6f849b9so121840466b.2
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 01:31:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683275478; x=1685867478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=DHBjqs3cEdpyi3ypGIzGOmjTiIfwwMe3ny2HorY+tRyCxTghoglSGZSo17pCm9FQ4T
         gZ5gjurBokXycKkJJ11knz7Y0RsDQmkg28jYJk36JbY341h7GvuFu/ZeluzQremEdbdp
         j9hxA/u0+gXrQU5CTO6faFLJXw18KWJZdBWdmUptial+FRghQCGWYvpycDF2wC5tD5mb
         3kk376Nv9DOZCW48jmbviHUr0B8UiqCehSARpStl2K5HT41gSflYqm597fU68WpkjAe7
         VlubEjaFG3NldYwInBr88tnnWYtAsvM3SlSo+l+7lHgEDReaJ+tpjJMQ+k/i0GTgka/p
         S/aQ==
X-Gm-Message-State: AC+VfDwcJIen2DgFAmOnMGiUjlUJ7WajIGVvnCeeuYiUwFq4SqO4IUZC
        Z1TZgWFwC9tzb7RP+v8XUCW2f8fdFB/6dba7c0mpSDeObjfdEmIeqVMjKzkb9lrobo21i0dxPz5
        fe3vX2mNJRt33
X-Received: by 2002:a17:907:320a:b0:88a:1ea9:a5ea with SMTP id xg10-20020a170907320a00b0088a1ea9a5eamr393853ejb.65.1683275478235;
        Fri, 05 May 2023 01:31:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ47UpNCtDUMm+GtsuZ12J5zXngGazIrJDUL717pYZDeruU5J1EfBTnknDT9k0Mqqvc5kkvltQ==
X-Received: by 2002:a17:907:320a:b0:88a:1ea9:a5ea with SMTP id xg10-20020a170907320a00b0088a1ea9a5eamr393833ejb.65.1683275477852;
        Fri, 05 May 2023 01:31:17 -0700 (PDT)
Received: from [192.168.10.118] ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.gmail.com with ESMTPSA id bz6-20020a1709070aa600b0095850aef138sm642491ejc.6.2023.05.05.01.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 01:31:17 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Babu Moger <babu.moger@amd.com>
Cc:     pbonzini@redhat.com, richard.henderson@linaro.org,
        weijiang.yang@intel.com, philmd@linaro.org, dwmw@amazon.co.uk,
        paul@xen.org, joao.m.martins@oracle.com, qemu-devel@nongnu.org,
        mtosatti@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        marcel.apfelbaum@gmail.com, yang.zhong@intel.com,
        jing2.liu@intel.com, vkuznets@redhat.com, michael.roth@amd.com,
        wei.huang2@amd.com, berrange@redhat.com, bdas@redhat.com
Subject: Re: [PATCH v4 0/7] Add EPYC-Genoa model and update previous EPYC Models
Date:   Fri,  5 May 2023 10:31:16 +0200
Message-Id: <20230505083116.82505-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230504205313.225073-1-babu.moger@amd.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo

