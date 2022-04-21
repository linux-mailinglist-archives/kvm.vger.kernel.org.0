Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C4E50A754
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 19:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390886AbiDURrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 13:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390877AbiDURrx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 13:47:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0550C2AC0
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 10:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650563102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y85+6pw41kbzffV7AbcQ383URpp068z7QwvGuQiAdfo=;
        b=iZzaRVfIFxyu6cH5pd0YyAz5yYAPX9vo0giIK/yaULW7lwF3k5nc6mGyGNyQZ+9WgzJpnB
        tU9cmm6yFV5RosDVL0fnril/nmTBD1l5hbPlMPfhpxrwkkvS1mIbG69TbTl3/GEZT2n1ou
        XZR3BhFNtBX1bNgng+YuCnCsJly+PC0=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-f5Qy-fhFNqCL0WsTT1qLLg-1; Thu, 21 Apr 2022 13:45:00 -0400
X-MC-Unique: f5Qy-fhFNqCL0WsTT1qLLg-1
Received: by mail-il1-f197.google.com with SMTP id s10-20020a92c5ca000000b002cc45dade1aso3022294ilt.20
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 10:45:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y85+6pw41kbzffV7AbcQ383URpp068z7QwvGuQiAdfo=;
        b=IROnWseqUFiTKY/GeOFcPHJXszVppDyLELCzqnNNvD+9Ho47s2DOM7tGApXAM11n9k
         3M8UsnBoJU2b7X9pXP5jF2ZMH6wTQYj+qTmSeF0XwP/dbPjW9xLeMyM4w0I9k1imffj9
         3dCtypRkl9Rka3UhBH2JDAtk3MbFRu/FgLRJym3MTjSkDwxQD5PGoVrpOOCMV9uUlJZV
         YtySEFIlbLvgm4zANNmMZgXPB/QAbcEbxJPpF3g2aQHeUOYNcm9Ra0vFpGjcvdfikaz5
         5rPRZVxXtVoeeGMavAIEIRfK7GVeF0hGE3ym9ZWBhpmibuf7CkuPS3fMMNBZWrDeYQWR
         v69A==
X-Gm-Message-State: AOAM533ZlEtkSDczeT+r3e59NbgIuKhh9b35/kG3sunDTX/aAkBsltic
        QN10FrpaUj9VRJYzSRVolbLNmpa9AJJobdF4q2U39UI0wLp78+Saq62HV7rRaYs9SH89sRzOMvr
        6OL3V6ESxiC2J
X-Received: by 2002:a92:bf06:0:b0:2c9:b21d:6db7 with SMTP id z6-20020a92bf06000000b002c9b21d6db7mr402154ilh.222.1650563100050;
        Thu, 21 Apr 2022 10:45:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNjQU8wehmsvLvkrXczfzhPEQN+KmNB8g9/3LZORPgKu188DGWDpaGaZAfFNWhz6RszU0w9Q==
X-Received: by 2002:a92:bf06:0:b0:2c9:b21d:6db7 with SMTP id z6-20020a92bf06000000b002c9b21d6db7mr402146ilh.222.1650563099816;
        Thu, 21 Apr 2022 10:44:59 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id a9-20020a926609000000b002ca50234d00sm12250347ilc.2.2022.04.21.10.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 10:44:59 -0700 (PDT)
Date:   Thu, 21 Apr 2022 13:44:57 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v6 02/10] KVM: selftests: Read binary stats header in lib
Message-ID: <YmGYGXlNdSEeFeeo@xz-m1.local>
References: <20220420173513.1217360-1-bgardon@google.com>
 <20220420173513.1217360-3-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220420173513.1217360-3-bgardon@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 20, 2022 at 10:35:05AM -0700, Ben Gardon wrote:
> Move the code to read the binary stats header to the KVM selftests
> library. It will be re-used by other tests to check KVM behavior.
> 
> No functional change intended.
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

