Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E7E1B6615
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 23:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgDWVSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 17:18:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25964 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726057AbgDWVSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 17:18:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587676714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1yCkXI2AJ6i3d0c/0eyg6uFGIIfpRPd2ihuAJVzPPyo=;
        b=VCCe7a2fWo/rlJOF6DBFFu6h40mz6MuSHckDGUwWqSB4IbTFoSI2awHUYQARhw2ixt0UQ4
        6PYISAnDJcjDSu67EY/27ZFj5AME41j7SB/ytdNqqQ9I9l31hJfmA912dFNe9lpmRXb8MM
        gEBYGs2wxtUPQbJPS2VL24r2Iy26OcY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-cXUZb7oNNvS4m5M1URw54A-1; Thu, 23 Apr 2020 17:18:32 -0400
X-MC-Unique: cXUZb7oNNvS4m5M1URw54A-1
Received: by mail-wr1-f71.google.com with SMTP id s11so3482445wru.6
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 14:18:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1yCkXI2AJ6i3d0c/0eyg6uFGIIfpRPd2ihuAJVzPPyo=;
        b=miutyUGfaH/fr5jgETzMwanpdMRNDzO2c2abvbVUXizQy+ma145ZHq24UlX9wfpxkV
         4D142hv0JZyl3Us/PaF2FCymxQGTk7ODDBaQt7YsfpS/MVxfNDQZLy/4115WzE3suLDP
         2ToKjlJI0X0TWmkYnf5gjYYBuCFZgje5jw0dXbC7WsGblK6lxfERPJl0sYfdm8PUu120
         1j6hMFlVtadPClVuK0m0W8fDTU4NozmhMa211nowtesiYrjN7VVaFbtXBv+PbrrNtJaj
         Etl6bt1HY2wMqAGYs47DPq1soR8Q8HdMz28Lie3JJnau+P40WRoqQBMnmczD4IbtwPOO
         1vTQ==
X-Gm-Message-State: AGi0PuaP0NaRPRAU6qr0LyQpJdswQQ3kvKTxjZs+ts9RnrQ9YJEq1B/F
        WeevLRALRop2yBOL1xftTr+Dm2/rXEd93RuS23FXzC/wHtGNKnFf0QDJQkyDZ5JogXoUohiMeE/
        XnzQbbcL+t9kQ
X-Received: by 2002:a5d:52d1:: with SMTP id r17mr6691450wrv.333.1587676711153;
        Thu, 23 Apr 2020 14:18:31 -0700 (PDT)
X-Google-Smtp-Source: APiQypI05e9TJ8Ng8lFyXdnppof1qVibvmVtJL8//5P7OHSsBWeaFHHXaV05OE/Zdc47L2GYzGYV6w==
X-Received: by 2002:a5d:52d1:: with SMTP id r17mr6691430wrv.333.1587676710922;
        Thu, 23 Apr 2020 14:18:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id s12sm39356wmc.7.2020.04.23.14.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 14:18:30 -0700 (PDT)
Subject: Re: [kvm PATCH 2/2] KVM: nVMX: Don't clobber preemption timer in the
 VMCS12 before L2 ran
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Makarand Sonare <makarandsonare@google.com>,
        kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
References: <20200417183452.115762-1-makarandsonare@google.com>
 <20200417183452.115762-3-makarandsonare@google.com>
 <20200422015759.GE17836@linux.intel.com>
 <20200422020216.GF17836@linux.intel.com>
 <CALMp9eRUE7hRNUohhAuz8UoX0Zu1LtoXum7inuqW5ROy=m1hyQ@mail.gmail.com>
 <d1910ba0-13b0-1e82-06d1-b349632149e4@redhat.com>
 <CALMp9eQuMEmFFpsF97O+CjF9EcBBTZHx86eyTXZvz-HD93kKPg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <739ca3fb-f5ac-856f-922f-0f5777e3a370@redhat.com>
Date:   Thu, 23 Apr 2020 23:18:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQuMEmFFpsF97O+CjF9EcBBTZHx86eyTXZvz-HD93kKPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 23:11, Jim Mattson wrote:
> On Thu, Apr 23, 2020 at 7:58 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>> On 22/04/20 19:05, Jim Mattson wrote:
>>> I don't have a strong objection to this patch. It just seems to add
>>> gratuitous complexity. If the consensus is to take it, the two parts
>>> should be squashed together.
>> The complexity is not much if you just count lines of code, but I agree
>> with you that it's both allowed and more accurate.
> It sounds like we're in agreement that this patch can be dropped?
> 

Yes.

Paolo

