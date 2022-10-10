Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C645FA155
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 17:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiJJPmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 11:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiJJPmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 11:42:35 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D6573921
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 08:42:33 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id n18-20020a17090ade9200b0020b0012097cso8757175pjv.0
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 08:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XtnSHLqwl0JncHnC0kbBtI/PL8afRq+ewcFC6JVcafw=;
        b=HvUB8l/MVD0KjZ07bjg1/qqcynG/naisbifIvUW4rce+qOfI9zZIsmBD75+aDWomYm
         91a3nLHd4bBu+DkVDGbbSzzVldKQFDi4324lct92vLN47L6MABk9SZMffEpNKw5nhsdW
         bUQqSWH+0ltXciCpjCqRRT0oRChsJ5zwFRu43r0BxIwvIcMaQD6Xb9QbCmCtJkFgZIuw
         pTl5W0ZONuYn881kYcjfhz0ggoc1E8GsvH3lvFQt2MYc98dJGHaB6FI413CXguTf0pPQ
         cwXrePYGmF+9RG8d0uacPG1oOg2QDHYv8Hg95SAUKCi4DiezTIQgUl2RplvMZ1wx96MD
         ZHDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XtnSHLqwl0JncHnC0kbBtI/PL8afRq+ewcFC6JVcafw=;
        b=s7fs1UM8KjW2oCzVeCn/nbGNIJhoE2glZnzwICz6EplpkCfCYWEO/CP3xykg/5lbpd
         ruhxRTbpYHxEdG/zlr+tchg0q3V55IJXuW4ON5FoKfDWp/uxIcXaWQ7IG19aRy3NQZUs
         Tg5zpGWoHJPBqQV34peCF70Qs0QhuxS/thdEerp3sbaIqjlzrqCbW34Qo83XxWWWZw64
         UQWjGCIQCPQjeY8sHWsihpXSR4/Dr1fC6fItYHR27w2NPX9lDrsmeo/LusbevzKC932A
         PP5AWeUgnr1mMGqQpw6H0bDs2roVmBKuKicQo7JM/M8uVwmQ4msDYkWphfd/5fQk8efQ
         ehFw==
X-Gm-Message-State: ACrzQf2yV6vKQ6qbv7k1f3QmKOTtXlLi+Mu/4yktCTOQ2vx5X08bj0vr
        Lz5EQ8y4F+xb3mKWP1S9lASLZyTIrqBb+w==
X-Google-Smtp-Source: AMsMyM5E/OOPVm/wnbAx25PexUKTx1VT4xhvx/EOXKXkcUoht0KNMyF+pMYBjpr/DZMxXd25pc4xvw==
X-Received: by 2002:a17:90b:1e46:b0:20a:c49f:9929 with SMTP id pi6-20020a17090b1e4600b0020ac49f9929mr20939970pjb.221.1665416552710;
        Mon, 10 Oct 2022 08:42:32 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id cp17-20020a170902e79100b0017824e7065fsm6754205plb.180.2022.10.10.08.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 08:42:32 -0700 (PDT)
Date:   Mon, 10 Oct 2022 15:42:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v5 4/7] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
Message-ID: <Y0Q9ZFGQf1On/Cus@google.com>
References: <20220920174603.302510-1-aaronlewis@google.com>
 <20220920174603.302510-5-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920174603.302510-5-aaronlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 20, 2022, Aaron Lewis wrote:
>  static void convert_to_filter_events(struct kvm_pmu_event_filter *filter)
> @@ -645,7 +719,34 @@ static void convert_to_filter_events(struct kvm_pmu_event_filter *filter)
>  	for (i = 0; i < filter->nevents; i++) {
>  		u64 e = filter->events[i];
>  
> -		filter->events[i] = encode_filter_entry(e);
> +		filter->events[i] = encode_filter_entry(e, filter->flags);
> +	}
> +}
> +
> +/*
> + * Sort will order the list by exclude, then event select.  This function will
> + * then index the sublists of event selects such that when a search is done on
> + * the list, the head of the event select sublist is returned.  This simplifies
> + * the logic in filter_contains_match() when walking the list.

I'm not so sure that this is simpler overall though.  If inclusive vs. exclusive
are separate lists, then avoiding "index" would mean there's no need to convert
entries.  And IIUC, the only thing this saves in filter_contains_match() is
having to walk backwards, e.g. it's

	for (i = index; i < filter->nevents; i++) {
		if (!<eventsel event match>)
			break;

		if (is_filter_match(...))
			return true;
	}

	return false;

versus

	for (i = index; i < filter->nevents; i++) {
		if (filter_event_cmp(eventsel, filter->events[i]))
			break;

		if (is_filter_match(eventsel, filter->events[i]))
			return true;
	}

	for (i = index - 1; i > 0; i--) {
		if (filter_event_cmp(eventsel, filter->events[i]))
			break;

		if (is_filter_match(eventsel, filter->events[i]))
			return true;
	}

	return false;

It's definitely _more_ code in filter_contains_match(), and the duplicate code is
unfortunate, but I wouldn't necessarily say it's simpler.  There's a fair bit of
complexity in understanding the indexing scheme, it's just hidden.

And I believe if the indexing is dropped, then the same filter_event_cmp() helper
can be used for sort() and bsearch(), and for bounding the walks.

And here's also no need to "encode" entries or use a second struct overly.

We might need separate logic for the existing non-masked mechanism, but again
that's only more code, IMO it's not more complex.  E.g. I believe that the legacy
case can be handled with a dedicated:

	if (!(filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS))
		return find_filter_index(..., cmp_u64) > 0;

Oh, and as a bonus of splitting include vs. exclude, the legacy case effectively
optimizes exclude since the length of the exclude array will be '0'.

If we do keep the indexing, I think we should rename "index" to "head", e.g. like
"head pages", to make it more obvious that the helper returns the head of a list.

> + */
> +static void index_filter_events(struct kvm_pmu_event_filter *filter)
> +{
> +	struct kvm_pmu_filter_entry *prev, *curr;
> +	int i, index = 0;
> +
> +	if (filter->nevents)
> +		prev = (struct kvm_pmu_filter_entry *)(filter->events);
> +
> +	for (i = 0; i < filter->nevents; i++) {
> +		curr = (struct kvm_pmu_filter_entry *)(&filter->events[i]);
> +
> +		if (curr->event_select != prev->event_select ||
> +		    curr->exclude != prev->exclude) {
> +			index = 0;
> +			prev = curr;
> +		}
> +
> +		curr->event_index = index++;
>  	}
>  }
> + * When filter events are converted into this format then sorted, the
> + * resulting list naturally ends up in two sublists.  One for the 'include
> + * list' and one for the 'exclude list'.  These sublists are further broken
> + * down into sublists ordered by their event select.  After that, the
> + * event select sublists are indexed such that a search for: exclude = n,
> + * event_select = n, and event_index = 0 will return the head of an event
> + * select sublist that can be walked to see if a match exists.
> + */
>  struct kvm_pmu_filter_entry {
>  	union {
>  		u64 raw;
>  		struct {
> +			u64 mask:8;
> +			u64 match:8;
> +			u64 event_index:12;

This is broken.  There are 2^12 possible event_select values, but event_index is
the index into the full list of events, i.e. is bounded only by nevents, and so
this needs to be stored as a 32-bit value.  E.g. if userspace creates a filter
with 2^32-2 entries for eventsel==0, then the index for eventsel==1 will be
2^32-1 even though there are only two event_select values in the entire list.

>  			u64 event_select:12;
> -			u64 unit_mask:8;
> -			u64 rsvd:44;
> +			u64 exclude:1;
> +			u64 rsvd:23;
>  		};
>  	};
>  };
