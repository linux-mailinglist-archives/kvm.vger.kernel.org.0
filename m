Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1FE66EA639
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 10:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjDUIun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 04:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjDUIuJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 04:50:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A2DAF1A
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 01:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682066898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=KgpXidUXneE7dkbQEMmaUqDbchLJXxG+5n9VkNolXDj0DwL+hIbk+hc1WwqhUNq1edpjwd
        LAHthIriVajvGAtEQsUDtUL/o6zjjJaxubT9pH34eocj26Phlgj4eRigFHn8vCBv25Z0q1
        jHZTwiUkVmEwYwZEZzMNKf58w4y6guY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-nooS6etpPy6DuERdrr4gTw-1; Fri, 21 Apr 2023 04:48:15 -0400
X-MC-Unique: nooS6etpPy6DuERdrr4gTw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-953429dac27so118213166b.0
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 01:48:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682066894; x=1684658894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=Rn+B85RAY7w8G3c8nPww82kDbAIQ/OU1C/4tOFVQtfJEvudYmz7P7mQXYVTL8IDVEK
         edUD9ZvEZiSMWDFH1WL5+FqM0Un+kIENvMf9lvBi+V4mBXp0bYLGbvzBI1qX6yGF1man
         VJ36pGM5eSfouWz9AJ1U1RkBfQKLlEjMqgNNSrG0iQt6eD9MqXT7IWDyPjT0NwGH0oCj
         osUp0zqUQix28kqX/6dnJJbLtBuYC2/UB1FUiS3XJSP14vEmHbxCYE2MfS8Nzx5xYsK+
         +sj4TIr/Qj19GJiB1dAlP19DUIA2I/M/Ebd3QnZhg4RWsuXwy4oE5wO+Uh0TfF8DT7as
         F9eQ==
X-Gm-Message-State: AAQBX9e7H3h0n56p822IauYnNMu+TByV1fHsMQIapTZfWW6OF3W9YZaQ
        s/3PSGdObXQBuRtnxPSVLCbgyOt9hsL9DENs/iyOrgF0RYgeyaePdfwVLNs5a1bQKgi1VEC957c
        hViurpLFhS7nP
X-Received: by 2002:a17:906:f295:b0:94f:1c1e:4222 with SMTP id gu21-20020a170906f29500b0094f1c1e4222mr1519210ejb.63.1682066894066;
        Fri, 21 Apr 2023 01:48:14 -0700 (PDT)
X-Google-Smtp-Source: AKy350aWWKuqvbOSrEETU5zSp0fBzI+nEuxYfq95fqAzazQbqcwDmQO09E32WhoCfdXpX16ZYLYARA==
X-Received: by 2002:a17:906:f295:b0:94f:1c1e:4222 with SMTP id gu21-20020a170906f29500b0094f1c1e4222mr1519187ejb.63.1682066893730;
        Fri, 21 Apr 2023 01:48:13 -0700 (PDT)
Received: from [192.168.10.118] ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm1812245ejb.140.2023.04.21.01.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 01:48:13 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH 0/4] Qemu SEV reduced-phys-bits fixes
Date:   Fri, 21 Apr 2023 10:48:12 +0200
Message-Id: <20230421084812.10215-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1664550870.git.thomas.lendacky@amd.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

